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
        assert_equal 'Fox', object.title
        assert_equal BigDecimal.new(resource.price), object.price
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

    test "it should be possible to initialize multiple records from a list of resources" do
      resources = [new_resource(id: 1), new_resource(id: 2)]
      objects = IntegrationObject.initialize_from_resources(resources)
      assert_equal 2, objects.size
    end

    test "it should be possible to initialize_from_resources with a single resource" do
      objects = IntegrationObject.initialize_from_resources(new_resource(id: 2))
      assert_equal 1, objects.size
    end

    test "it should be possible to create multiple records from a list of resources" do
      resources = [new_resource(id: 1), new_resource(id: 2)]
      assert_difference "IntegrationObject.count", 2 do
        objects = IntegrationObject.create_from_resources(resources)
        assert_equal 2, objects.count
      end
    end

    test "it should be possible to create_from_resources with a single resource" do
      assert_difference "IntegrationObject.count" do
        objects = IntegrationObject.create_from_resources(new_resource(id: 2))
        assert_equal 1, objects.count
      end
    end

    test "it should be possible to find initialize all relations for the object" do
      integration_object_relations_resources = [new_resource(id: 1, integration_object_id: 1, sku: 'saucey', option1: 'red')]
      resource = new_resource(integration_object_relations: integration_object_relations_resources)
      object = IntegrationObject.initialize_from_resource(resource)
      assert_equal 1, object.integration_object_relations.size
      relation = object.integration_object_relations.first
      assert_equal object.id, relation.integration_object_id
    end

    test "it should be possible to create all relations for the object" do
      integration_object_relations_resources = [
        new_resource(id: 1, integration_object_id: 1, sku: 'redsauce', option1: 'red'),
        new_resource(id: 2, integration_object_id: 1, sku: 'greensauce', option1: 'green')
      ]
      resource = new_resource(integration_object_relations: integration_object_relations_resources)
      assert_difference "IntegrationObjectRelation.count", 2 do
        assert_difference "IntegrationObject.count" do
          object = IntegrationObject.create_from_resource(resource)
        end
      end
    end

    test "it should be possible to create multiple records from a list of resources that also contain relationships" do
      int_obj_rel_1 = [
        new_resource(id: 1, integration_object_id: 1, sku: 'redsauce', option1: 'red'),
        new_resource(id: 2, integration_object_id: 1, sku: 'greensauce', option1: 'green')
      ]
      int_obj_rel_2 = [
        new_resource(id: 3, integration_object_id: 2, sku: 'redsauce', option1: 'red'),
        new_resource(id: 4, integration_object_id: 2, sku: 'greensauce', option1: 'green')
      ]
      resources = [
        new_resource(id: 1, integration_object_relations: int_obj_rel_1),
        new_resource(id: 2, integration_object_relations: int_obj_rel_2)
      ]
      assert_difference "IntegrationObjectRelation.count", 4 do
        assert_difference "IntegrationObject.count", 2 do
          objects = IntegrationObject.create_from_resources(resources)
          assert_equal 2, objects.count
          objects.each { |o| assert_equal 2, o.integration_object_relations.count }
        end
      end
    end

    private
    def new_resource(options={})
      defaults = {id: 1, title: 'Fox', price: '12.00'}.merge(options)
      ShopifyAPI::Product.new(defaults)
    end
  end
end
