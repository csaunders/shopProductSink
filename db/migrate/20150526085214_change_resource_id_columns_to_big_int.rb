class ChangeResourceIdColumnsToBigInt < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        # change columns that refer to resource IDs created in Shopify to 64-bit (8-byte) integers
        change_column :shop_product_sink_images, :product_id, :integer, limit: 8
        change_column :shop_product_sink_options, :product_id, :integer, limit: 8
        change_column :shop_product_sink_product_variants, :product_id, :integer, limit: 8
        change_column :shop_product_sink_product_variants, :image_id, :integer, limit: 8
        change_column :shop_product_sink_images, :id, :integer, limit: 8
        change_column :shop_product_sink_options, :id, :integer, limit: 8
        change_column :shop_product_sink_product_variants, :id, :integer, limit: 8
        change_column :shop_product_sink_products, :id, :integer, limit: 8
      end

      dir.down do
        change_column :shop_product_sink_images, :product_id, :integer
        change_column :shop_product_sink_options, :product_id, :integer
        change_column :shop_product_sink_product_variants, :product_id, :integer
        change_column :shop_product_sink_product_variants, :image_id, :integer
        change_column :shop_product_sink_images, :id, :integer
        change_column :shop_product_sink_options, :id, :integer
        change_column :shop_product_sink_product_variants, :id, :integer
        change_column :shop_product_sink_products, :id, :integer
      end
    end
  end
end
