class CreateShopProductSinkProductVariants < ActiveRecord::Migration
  def change
    create_table :shop_product_sink_product_variants do |t|
      t.string :barcode
      t.string :compare_at_price
      t.string :fulfillment_service
      t.integer :grams
      t.string :inventory_management
      t.string :inventory_policy
      t.string :inventory_quantity
      t.text :metafield
      t.text :option
      t.string :position
      t.decimal :price, precision: 10, scale: 2
      t.integer :product_id
      t.boolean :requires_shipping
      t.string :sku
      t.boolean :taxable
      t.string :title

      t.timestamps
    end
  end
end
