module ShopProductSink
  class Product < ActiveRecord::Base
    has_many :product_variants
  end
end
