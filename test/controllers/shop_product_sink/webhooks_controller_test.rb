require 'test_helper'

module ShopProductSink
  class WebhooksControllerTest < ActionController::TestCase

    setup do
      ShopifyAPI::Base.site = "https://example.myshopify.com/admin"
      WebhooksController.any_instance.stubs(:application_secret).returns('abracadabra')
    end

    test "when a product creation event occurs" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_create')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/create'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 247905905
      assert_difference "ShopProductSink::Product.count" do
        post :create, use_route: :shop_product_sink
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product hasn't been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_difference "ShopProductSink::Product.count" do
        post :create, use_route: :shop_product_sink
        assert_response :ok
      end
    end

    test "when a product update event occurs and the product has been synchronized" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      ShopProductSink::Product.create(id: 156731111)
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_no_difference "ShopProductSink::Product.count" do
        post :create, use_route: :shop_product_sink
        assert_response :ok
      end
    end

    test "when a product deletion event occurs" do
      WebhooksController.any_instance.expects(:valid_webhook?).returns(true)
      ShopProductSink::Product.create(id: 156731111)
      @request.env['RAW_POST_DATA'] = ''
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/delete'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      assert_difference "ShopProductSink::Product.count", -1 do
        post :create, use_route: :shop_product_sink
        assert_response :ok
      end
    end

    test "when an forged request comes in" do
      @request.env['RAW_POST_DATA'] = ShopifyJson.read_file('product_update')
      @request.env['HTTP_X_SHOPIFY_TOPIC'] = 'products/update'
      @request.env['HTTP_X_SHOPIFY_PRODUCT_ID'] = 156731111
      @request.env['HTTP_X_SHOPIFY_HMAC_SHA256'] = 'dsfdfasfsdafasdfdsa'
      post :create, use_route: :shop_product_sink
      assert_response :unauthorized
    end
  end
end
