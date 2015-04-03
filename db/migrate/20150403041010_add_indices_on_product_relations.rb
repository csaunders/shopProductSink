class AddIndicesOnProductRelations < ActiveRecord::Migration
  def change
    add_index :shop_product_sink_product_variants, :product_id
    add_index :shop_product_sink_options, :product_id
    add_index :shop_product_sink_images, :product_id
  end
end
