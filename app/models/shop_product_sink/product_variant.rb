module ShopProductSink
  class ProductVariant < ActiveRecord::Base
    include ApiCreatable
    belongs_to :product
  end
end
