require_dependency "shop_product_sink/application_controller"

module ShopProductSink
  class WebhooksController < ApplicationController
    include ShopProductSink::Webhooks
    include ShopProductSink::Shop

    before_action :shopify_resource_setup

    def create
      handle_creation
      handle_update
      handle_deletion
      head :ok
    end

    def application_secret
      ENV['SHOPIFY_APP_SECRET'] || ENV['SHOPIFY_API_SECRET']
    end

    def handle_creation
      return unless create?
      initialize_model.save! unless resource_class.exists?(resource_id)
    end

    def handle_update
      return unless update?
      remove_resource
      initialize_model.save!
    end

    def handle_deletion
      return unless delete?
      remove_resource
    end

    private
    def remove_resource
      resource_class.where(id: resource_id).destroy_all
    end

    def resource_class
      ShopProductSink::Product
    end

    def shopify_resource_setup
      ShopifyAPI::Base.site = '/' if ShopifyAPI::Base.site.nil?
    end

    def shopify_resource
      ShopifyAPI::Product
    end

    def shopify_object
      shopify_resource.new(request.params)
    end

    def initialize_model
      model = resource_class.initialize_from_resource(shopify_object)
      model.shop_id = shop_id
      model
    end
  end
end
