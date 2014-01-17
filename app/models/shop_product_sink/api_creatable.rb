module ShopProductSink
  module ApiCreatable
    extend ActiveSupport::Concern

    module ClassMethods
      def initialize_from_resource(resource)
        attributes = usable_keys.reduce({}) do |result, key|
          result[key] = resource.public_send(key) if resource.respond_to?(key)
          result
        end
        self.new(attributes)
      end

      def create_from_resource(resource)
        initialize_from_resource(resource).save
      end

      def usable_keys
        columns.map(&:name)
      end

    end
  end
end
