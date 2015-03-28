module ShopProductSink
  class Product < ActiveRecord::Base
    include ApiCreatable
    has_many :product_variants, dependent: :delete_all
    has_many :options, dependent: :delete_all
  end
end
