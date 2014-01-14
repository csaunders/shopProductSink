class CreateShopProductSinkProducts < ActiveRecord::Migration
  def change
    create_table :shop_product_sink_products do |t|
      t.text :body_html
      t.string :handle
      t.text :options
      t.string :product_type
      t.datetime :published_at
      t.string :published_scope
      t.text :tags
      t.string :template_suffix
      t.string :title
      t.string :vendor

      t.timestamps
    end
  end
end
