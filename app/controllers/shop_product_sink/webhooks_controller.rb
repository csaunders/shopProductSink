require_dependency "shop_product_sink/application_controller"

module ShopProductSink
  class WebhooksController < ApplicationController
    include ShopProductSink::Webhooks

    def create
    end

    def application_secret
      ENV['SHOPIFY_API_SECRET']
    end
  end
end
