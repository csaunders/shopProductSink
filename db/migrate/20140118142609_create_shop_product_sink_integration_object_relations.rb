class CreateShopProductSinkIntegrationObjectRelations < ActiveRecord::Migration
  def change
    create_table :shop_product_sink_integration_object_relations do |t|
      t.integer :integration_object_id
      t.string :sku
      t.string :option1
    end
  end
end
