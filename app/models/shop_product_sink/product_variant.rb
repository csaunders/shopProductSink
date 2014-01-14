module ShopProductSink
  class ProductVariant < ActiveRecord::Base
    belongs_to :product
  end
end
