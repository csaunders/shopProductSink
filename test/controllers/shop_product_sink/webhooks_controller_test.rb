require 'test_helper'

module ShopProductSink
  class WebhooksControllerTest < ActionController::TestCase

    setup do
      @routes = Engine.routes
      @request.env['CONTENT_TYPE'] = 'application/json'
      ShopifyAPI::Base.site = "https://example.myshopify.com/admin"
      WebhooksController.any_instance.stubs(:application_secret).returns('abracadabra')
      @product_and_relations = [
        "ShopProductSink::Product.count",
        "ShopProductSink::ProductVariant.count",
        "ShopProductSink::Option.count"
      ]
    end

    test "when a product creation event occurs" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_create')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/create'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 247905905
      assert_difference @product_and_relations do
        post :create, ShopifyJson.read_full_json('product_create')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product hasn't been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_difference @product_and_relations do
        post :create, ShopifyJson.read_full_json('product_update')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product has been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      params = { id: 156731111 }
      ShopProductSink::Product.create(params)
      ShopProductSink::ProductVariant.create(product_id: params[:id])
      ShopProductSink::Option.create(product_id: params[:id])
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_no_difference @product_and_relations do
        post :create, ShopifyJson.read_full_json('product_update')
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product has been synchronized with a different number of variants and options" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      params = { id: 156731111 }
      ShopProductSink::Product.create(params)
      # create two options and variants
      2.times do |x|
        ShopProductSink::Option.create(product_id: params[:id])
        ShopProductSink::ProductVariant.create(product_id: params[:id])
      end

      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
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
      ShopProductSink::Product.create(params)
      ShopProductSink::ProductVariant.create(product_id: params[:id])
      ShopProductSink::Option.create(product_id: params[:id])
      @request.env['RAW_POST_DATA'] = ActiveSupport::JSON.encode(params)
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/delete'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = params[:id]
      assert_difference @product_and_relations, -1 do
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
