class CreateShopProductSinkOptions < ActiveRecord::Migration
  def up
    create_table :shop_product_sink_options do |t|
      t.integer :product_id
      t.string :name
      t.integer :position
    end

    remove_column :shop_product_sink_products, :options
  end

  def down
    add_column :shop_product_sink_products, :options
    drop_table :shop_product_sink_options
  end
end
