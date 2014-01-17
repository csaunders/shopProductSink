module ShopProductSink
  class IntegrationObject < ActiveRecord::Base
    class Error < StandardError; end
    include ApiCreatable

    def save
      unless Rails.env.test?
        raise Error, "Cannot use IntegrationObject in non-test environment"
      end
      super
    end
  end
end
