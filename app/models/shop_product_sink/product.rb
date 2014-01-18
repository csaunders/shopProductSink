module ShopProductSink
  class Product < ActiveRecord::Base
    include ApiCreatable
    has_many :product_variants
  end
end
