module ShopProductSink
  module Shop
    class ConfigurationError < StandardError; end
    extend ActiveSupport::Concern

    def shop
      return @shop unless @shop.nil?

      shop_class = ShopProductSink.shop_class
      shop_class = shop_class.constantize unless shop_class.nil?
      shop_lookup_method = ShopProductSink.shop_lookup_method || :find_by_domain
      if shop_class && shop_class.respond_to?(shop_lookup_method)
        # call lookup method with shopify shop domain as argument
        @shop = shop_class.send(shop_lookup_method, shopify_shop_domain)
      end
    end

    def shop_id
      shop && shop.respond_to?(:id) ? shop.id : nil
    end
  end
end
