module ShopProductSink
  class Product < ActiveRecord::Base
    include ApiCreatable
    belongs_to :shop, class_name: ShopProductSink.shop_class
    has_many :product_variants, dependent: :delete_all
    has_many :options, dependent: :delete_all
  end
end
