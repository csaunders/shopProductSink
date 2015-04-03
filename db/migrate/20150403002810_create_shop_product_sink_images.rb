class CreateShopProductSinkImages < ActiveRecord::Migration
  def change
    create_table :shop_product_sink_images do |t|
      t.integer :position, limit: 2
      t.integer :product_id
      t.text :src

      t.timestamps null: false
    end
  end
end
