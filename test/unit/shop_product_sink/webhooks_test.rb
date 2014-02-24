require 'test_helper'

module ShopProductSink
  class WebhooksTest < ActiveSupport::TestCase

    class ControllerDouble
      def self.skip_before_filter(*args); end
      def self.before_filter(*args); end

      include ShopProductSink::Webhooks
      attr_accessor :application_secret, :request
      def initialize(application_secret)
        @application_secret = application_secret
      end
    end

    test "authenticating a request" do
      controller('abracadabra')
      hmac = "u8aZR7htZKE6uWRg6M7+hTZJXZpcRmh5P4syND1EM24="
      controller.request = request('a message from shopify', hmac)
      assert controller.valid_webhook?
    end

    test "extracting the topic" do
      controller('abracadabra')
      controller.request = request('')
      assert_equal 'product', controller.affected_resource
      assert_equal 'create', controller.event
    end

    test "extracting the product id" do
      controller('abracadabra')
      controller.request = request('', nil, 'HTTP_X_SHOPIFY_PRODUCT_ID' => 12345)
      assert_equal 12345, controller.resource_id
    end

    test "when the webhook does not contain signing details" do
      controller('')
      options = {
        :method => 'POST',
        'CONTENT_TYPE' => 'application/json',
        :input => '',
        'HTTP_X_SHOPIFY_TOPIC' => 'products/create'
      }
      controller.request = ActionDispatch::Request.new(Rack::MockRequest.env_for("", options))
      assert controller.valid_webhook?, "Webhooks automatically pass validation if no signature is provided"
      assert controller.no_signing_details?, "Webhooks are aware that no signing details were given in the request"
    end

    def controller(secret=nil)
      if secret.nil?
        @controller
      else
        @controller = ControllerDouble.new(secret)
      end
    end

    def request(data, hmac=nil, headers = {})
      options = {
        :method => 'POST',
        'CONTENT_TYPE' => 'application/json',
        :input => data,
        'HTTP_X_SHOPIFY_HMAC_SHA256' => hmac || calculate_hmac(data),
        'HTTP_X_SHOPIFY_TOPIC' => 'products/create'
      }.merge(headers)
      ActionDispatch::Request.new(Rack::MockRequest.env_for("", options))
    end

    def calculate_hmac(data)
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.digest(digest, controller.application_secret, data)
      Base64.strict_encode64(hmac)
    end

  end
end
