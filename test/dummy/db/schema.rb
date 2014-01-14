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

ActiveRecord::Schema.define(version: 20140114000310) do

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
    t.text     "options"
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
