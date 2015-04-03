require 'test_helper'

module ShopProductSink
  class WebhooksControllerTest < ActionController::TestCase

    setup do
      @routes = Engine.routes
      @request.env['CONTENT_TYPE'] = 'application/json'
      ShopifyAPI::Base.site = "https://example.myshopify.com/admin"
      WebhooksController.any_instance.stubs(:application_secret).returns('abracadabra')
    end

    def create_product_with_relations(params, n_relations = 1)
      ShopProductSink::Product.create(params)

      relation_params = { product_id: params[:id] }

      # create n number of relations
      n_relations.times do |x|
        ShopProductSink::ProductVariant.create(relation_params)
        ShopProductSink::Option.create(relation_params)
      end
    end

    test "when a product creation event occurs" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_create')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/create'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 247905905
      assert_difference product_and_relations_difference do
        post :create, ShopifyJson.read_full_json('product_create')
        assert_response :ok
      end
    end

    test "when a product creation event occurs and the product has already been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      params = { id: 247905905 }
      create_product_with_relations(params)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_create')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/create'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = params[:id]

      assert_no_difference product_and_relations_difference do
        post :create, ShopifyJson.read_full_json('product_create')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product hasn't been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_difference product_and_relations_difference do
        post :create, ShopifyJson.read_full_json('product_update')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product has been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      params = { id: 156731111 }
      create_product_with_relations(params)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = params[:id]
      assert_no_difference product_and_relations_difference do
        post :create, ShopifyJson.read_full_json('product_update')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product has been synchronized with a different number of variants and options" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      params = { id: 156731111 }
      # create two options and variants
      create_product_with_relations(params, 2)

      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = params[:id]
      full_json = ShopifyJson.read_full_json('product_update')
      assert_no_difference "ShopProductSink::Product.count" do
        post :create, full_json
        assert_response :ok
      end

      # new count for variants and options should match json fixture file
      assert_equal full_json["variants"].size, ShopProductSink::ProductVariant.count, "variants count"
      assert_equal full_json["options"].size, ShopProductSink::Option.count, "options count"
    end

    test "when a product deletion event occurs" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      # delete webhook json only contains id
      params = { id: 156731111 }
      create_product_with_relations(params)

      @request.env['RAW_POST_DATA'] = ActiveSupport::JSON.encode(params)
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/delete'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = params[:id]
      assert_difference product_and_relations_difference, -1 do
        post :create, params
        assert_response :ok
      end
    end

    test "when an forged request comes in" do
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      @request.env['HTTP_X_SHOPIFY_HMAC_SHA256'] = 'dsfdfasfsdafasdfdsa'
      post :create, ShopifyJson.read_full_json('product_update')
      assert_response :unauthorized
    end
  end
end
