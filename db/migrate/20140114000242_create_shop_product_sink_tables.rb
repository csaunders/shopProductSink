class CreateShopProductSinkTables < ActiveRecord::Migration
  def change
    create_table "shop_product_sink_integration_object_relations", force: true do |t|
      t.integer "integration_object_id"
      t.string  "sku"
      t.string  "option1"
    end

    create_table "shop_product_sink_integration_objects", force: true do |t|
      t.string  "title"
      t.decimal "price", precision: 10, scale: 2
    end

    create_table "shop_product_sink_options", force: true do |t|
      t.integer "product_id"
      t.string  "name"
      t.integer "position"
    end

    create_table "shop_product_sink_product_variants", force: true do |t|
      t.string   "barcode"
      t.string   "compare_at_price"
      t.string   "fulfillment_service"
      t.integer  "grams"
      t.string   "inventory_management"
      t.string   "inventory_policy"
      t.string   "inventory_quantity"
      t.text     "metafield"
      t.text     "option"
      t.string   "position"
      t.decimal  "price",                precision: 10, scale: 2
      t.integer  "product_id"
      t.boolean  "requires_shipping"
      t.string   "sku"
      t.boolean  "taxable"
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "shop_product_sink_products", force: true do |t|
      t.text     "body_html"
      t.string   "handle"
      t.string   "product_type"
      t.datetime "published_at"
      t.string   "published_scope"
      t.text     "tags"
      t.string   "template_suffix"
      t.string   "title"
      t.string   "vendor"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
