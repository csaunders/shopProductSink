module ShopProductSink
  module Importers
    class Product
      include ShopProductSink::Shop

      PAGE_SIZE = 250

      attr_accessor :session
      def initialize(options = {})
        setup_private_app(options[:site])
        setup_partner_app(options.except(:site))
        shopify_shop_domain(options)
      end

      def import(options={})
        products = retrieve(options)
        ShopProductSink::Product.create_from_resources(products, shop_id)
      end

      def retrieve(options={})
        # FIXME: pagination stops at page 1 and/or 50 products
        products = []
        limit = options[:limit] || PAGE_SIZE
        page = 1
        begin
          retrieved_products = fetch(page, limit)
          products << retrieved_products
          page += 1
        end while retrieved_products.length == limit
        products.flatten!
      end

      def fetch(page, limit)
        ShopifyAPI::Product.find(:all, query: {page: page, limit: limit}) || []
      end

      def shopify_shop_domain(options = {})
        @shopify_shop_domain ||= options[:shop]
      end

      private
      def setup_private_app(site)
        return unless site
        ShopifyAPI::Base.site = site
      end

      def setup_partner_app(options)
        return unless options[:shop] && options[:token]
        self.session = ShopifyAPI::Session.new(options[:shop], options[:token])
        ShopifyAPI::Base.activate_session(session)
      end
    end
  end
end
