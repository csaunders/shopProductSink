class AddShopIdToShopProductSinkProducts < ActiveRecord::Migration
  def change
    add_column :shop_product_sink_products, :shop_id, :integer
    add_index :shop_product_sink_products, :shop_id
  end
end
