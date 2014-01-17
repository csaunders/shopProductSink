class CreateShopProductSinkIntegrationObjects < ActiveRecord::Migration
  def change
    create_table :shop_product_sink_integration_objects do |t|
      t.string :title
      t.decimal :price, precision: 10, scale: 2
    end
  end
end
