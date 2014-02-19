require 'test_helper'

module ShopProductSink
  class WebhookRegistrationTest < ActiveSupport::TestCase
    include ShopProductSink::Engine.routes.url_helpers

    setup do
      # TODO: Cannot set to nil after because of Mocha stubbing.
      # Unstubbing will apparently cause some failures to pass by mistake
      # which is less idea. This may cause test leakage though I'm not completely
      # sure. -- csaunders @ 18 Feb, 2014
      ShopifyAPI::Base.site = "https://getsthe:teststoevenrun@someshop.example.com/admin"
    end

    test "that when no URL is provided the default webhook route is used" do
      expected_arguments = [
        {topic: 'products/create', address: webhooks_url, format: 'json'},
        {topic: 'products/update', address: webhooks_url, format: 'json'},
        {topic: 'products/delete', address: webhooks_url, format: 'json'}
      ]
      expect_webhook_creation(expected_arguments)
      WebhookRegistration.register(site: private_app)
    end

    test "that when no information is passed in for the session to be prepared an error is raised" do
      assert_raises WebhookRegistration::InvalidConfigurationError do
        WebhookRegistration.register()
      end
    end

    test "that when information is passed in for a session to be created that is used" do
      session = ShopifyAPI::Session.new('oaklabs.myshopify.com', 'pokédex4science')
      ShopifyAPI::Session.expects(:new).with('oaklabs.myshopify.com', 'pokédex4science').returns(session)
      ShopifyAPI::Base.expects(:activate_session).with(session)
      expected_arguments = [
        {topic: 'products/create', address: address, format: 'json'},
        {topic: 'products/update', address: address, format: 'json'},
        {topic: 'products/delete', address: address, format: 'json'}
      ]
      expect_webhook_creation(expected_arguments)
      WebhookRegistration.register(shop: 'oaklabs.myshopify.com', token: 'pokédex4science', url: address)
    end

    test "that when information is passed in for a private application the site is set" do
      expected_arguments = [
        {topic: 'products/create', address: address, format: 'json'},
        {topic: 'products/update', address: address, format: 'json'},
        {topic: 'products/delete', address: address, format: 'json'}
      ]
      expect_webhook_creation(expected_arguments)
      ShopifyAPI::Base.expects(:site=).with(private_app)
      WebhookRegistration.register(site: private_app, url: address)
    end

    private

    def private_app
      'https://bidoof:pidgey@oaklabs.myshopify.com/admin'
    end

    def address
      'http://oaklabshandler.example.com/'
    end

    def webhooks_url
      webhooks_process_url(Rails.application.routes.default_url_options)
    end

    def expect_webhook_creation(args)
      webhooks_to_args = args.map{|arg| [ShopifyAPI::Webhook.new(arg), arg]}
      webhooks_to_args.each do |webhook, arg|
        ShopifyAPI::Webhook.expects(:create).with(arg).returns(webhook)
      end
    end
  end
end
