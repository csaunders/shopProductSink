require 'test_helper'

module ShopProductSink
  class ApiCreatableTest < ShopProductSink::UnitTest
    attr_reader :resource
    def additional_setup
      @resource = ShopifyAPI::Product.new(id: 1, title: 'Fox', price: "12.00")
    end

    test "it should be possible to initialize a record object from a resource" do
      object = IntegrationObject.initialize_from_resource(resource)
      assert_equal resource.id, object.id
      assert_equal resource.title, object.title
      assert_equal BigDecimal.new(resource.price), object.price
    end

    test "it should be possible to create a record from a resource" do
      assert_difference "IntegrationObject.count" do
        object = IntegrationObject.create_from_resource(resource)
      end
    end

    test "it should ignore fields that are on the resource but not supported in the object" do
      resource = ShopifyAPI::Product.new(id: 1, sneaky: 'deeky', title: 'Fox')
      object = IntegrationObject.initialize_from_resource(resource)
      assert_equal nil, object.attributes[:sneaky]
      assert_equal resource.id, object.id
      assert_equal resource.title, object.title
      assert_equal nil, object.price
    end
  end
end
