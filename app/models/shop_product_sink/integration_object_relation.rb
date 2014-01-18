module ShopProductSink
  class IntegrationObjectRelation < ActiveRecord::Base
    class Error < StandardError; end
    include ApiCreatable
    belongs_to :integration_object

    def save(*args)
      unless Rails.env.test?
        raise Error, "Cannot use IntegrationObjectRelation in non-test environment"
      end
      super
    end
  end
end
