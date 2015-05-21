class AddImageIdWeightFieldsToProductVariants < ActiveRecord::Migration
  def change
    add_column :shop_product_sink_product_variants, :weight, :integer
    add_column :shop_product_sink_product_variants, :weight_unit, :string
    add_column :shop_product_sink_product_variants, :image_id, :integer
  end
end
