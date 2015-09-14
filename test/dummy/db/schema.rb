# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150526085214) do

  create_table "shop_product_sink_images", force: :cascade do |t|
    t.integer  "position",   limit: 2
    t.integer  "product_id"
    t.text     "src"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "shop_product_sink_images", ["product_id"], name: "index_shop_product_sink_images_on_product_id"

  create_table "shop_product_sink_integration_object_relations", force: :cascade do |t|
    t.integer "integration_object_id"
    t.string  "sku"
    t.string  "option1"
  end

  create_table "shop_product_sink_integration_objects", force: :cascade do |t|
    t.string  "title"
    t.decimal "price", precision: 10, scale: 2
  end

  create_table "shop_product_sink_options", force: :cascade do |t|
    t.integer "product_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "shop_product_sink_options", ["product_id"], name: "index_shop_product_sink_options_on_product_id"

  create_table "shop_product_sink_product_variants", force: :cascade do |t|
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
    t.integer  "weight"
    t.string   "weight_unit"
    t.integer  "image_id"
  end

  add_index "shop_product_sink_product_variants", ["product_id"], name: "index_shop_product_sink_product_variants_on_product_id"

  create_table "shop_product_sink_products", force: :cascade do |t|
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
    t.integer  "shop_id"
  end

  add_index "shop_product_sink_products", ["shop_id"], name: "index_shop_product_sink_products_on_shop_id"

end
