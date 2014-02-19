module ShopProductSink
  class WebhookRegistration
    class InvalidConfigurationError < StandardError; end
    include ShopProductSink::Engine.routes.url_helpers

    attr_reader :url

    EVENTS = %w(create update delete)
    RESOURCES = %w(products)

    def self.register(options = {})
      registration = self.new(options)
      registration.register_resource_webhooks
    end

    def initialize(options)
      raise InvalidConfigurationError, 'Missing session information' unless setup_session(options)
      @url = options[:url] || default_webhook_url
    end

    def register_resource_webhooks
      RESOURCES.each { |resource| register_for_events(resource) }
    end

    def register_for_events(resource)
      EVENTS.each do |event|
        params = {topic: "#{resource}/#{event}", address: url, format: 'json'}
        ShopifyAPI::Webhook.create(params)
      end
    end

    private

    def setup_session(options)
      setup_private_app(options[:site]) || setup_partner_app(options)
    end

    def setup_private_app(site)
      return unless site
      ShopifyAPI::Base.site = site
    end

    def setup_partner_app(options)
      return unless options[:shop] && options[:token]
      session = ShopifyAPI::Session.new(options[:shop], options[:token])
      ShopifyAPI::Base.activate_session(session)
      session
    end

    def default_webhook_url
      @default_webhook_url ||= webhooks_process_url(Rails.application.routes.default_url_options)
    end
  end
end
