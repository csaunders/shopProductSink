module ShopProductSink
  module ApiCreatable
    extend ActiveSupport::Concern

    module ClassMethods
      def initialize_from_resource(resource)
        attributes = usable_keys.reduce({}) do |result, key|
          result[key] = resource.public_send(key) if resource.respond_to?(key)
          result
        end
        record = self.new(attributes)
        record.extract_relations!(resource)
        record
      end

      def initialize_from_resources(resources)
        Array[*resources].flatten.map { |resource| initialize_from_resource(resource) }
      end

      def create_from_resource(resource, shop_id = nil)
        object = initialize_from_resource(resource)
        object.shop_id = shop_id if shop_id && object.respond_to?(:shop_id)
        object.save
        object
      end

      def create_from_resources(resources, shop_id = nil)
        Array[*resources].flatten.map { |resource| create_from_resource(resource, shop_id) }
      end

      def usable_keys
        columns.map(&:name)
      end
    end

    def extract_relations!(resource)
      self.class.reflect_on_all_associations.each do |association|
      	# workaround for variants association name
      	association_name = association.name == :product_variants ? :variants : association.name

        if resource.respond_to?(association_name)
          resource_or_resources = resource.public_send(association_name)
          records = association.klass.initialize_from_resources(resource_or_resources)
          public_send("#{association.name}=", association.collection? ? records : records.first)
        end
      end
    end
  end
end
