require 'test_helper'

module ShopProductSink
  module Importers
    class ProductTest < ActiveSupport::TestCase
      attr_reader :importer

      setup do
        @importer = Importers::Product.new(site: 'https://api_key:password@anotherstore.myshopify.com')
      end

      teardown do
        ShopifyAPI::Base.site = nil
      end

      test "that it is possible to initialize an importer for a private app" do
        importer = Importers::Product.new(site: 'https://api_key:password@mystore.myshopify.com/admin')
        assert_equal nil, importer.session
        assert_equal 'https://api_key:password@mystore.myshopify.com/admin', ShopifyAPI::Base.site.to_s
      end

      test "that it is possible to initialize an importer for a partner app" do
        importer = Importers::Product.new(shop: 'mystore.myshopify.com', token: 'abcdef1234567890')
        assert importer.session, "The session should not be nil for the importer"
      end

      test "that it retrieves by default use a page size of #{Importers::Product::PAGE_SIZE}" do
        ShopifyAPI::Product.expects(:find).with(:all, query: {page: 1, limit: Importers::Product::PAGE_SIZE}).returns([])
        assert_equal [], importer.retrieve
      end

      test "can override the default page size" do
        ShopifyAPI::Product.expects(:find).with(:all, query: {page: 1, limit: 1}).returns([])
        assert_equal [], importer.retrieve(limit: 1)
      end

      test "gracefully handles if the API client returns nil" do
        ShopifyAPI::Product.expects(:find).returns(nil)
        assert_equal [], importer.retrieve
      end

      test "import takes the resulting API objects and stores them in the database" do
        results = [ShopifyJson.product('justmops_product')]
        ShopifyAPI::Product.expects(:find).returns(results)

        assert_difference "ShopProductSink::Product.count" do
          importer.import
        end
      end

    end
  end
end
