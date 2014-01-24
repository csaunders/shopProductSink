module ShopProductSink
  module Webhooks
    extend ActiveSupport::Concern

    def valid_webhook?
      request.body.rewind
      calculated_hmac = hmac(request.body.read)
      calculated_hmac = provided_hmac
    end

    def affected_resource
      topic.first.singularize
    end

    def event
      topic.last
    end

    private
    def digest
      OpenSSL::Digest::Digest.new('sha256')
    end

    def hmac(message)
      hmac = OpenSSL::HMAC.digest(digest, application_secret, message)
      Base64.strict_encode64(hmac)
    end

    def provided_hmac
      request.headers['X-Shopify-Hmac-SHA256']
    end

    def topic
      request.headers['X-Shopify-Topic'].split('/')
    end
  end
end
