module ShopProductSink
  class Image < ActiveRecord::Base
    include ApiCreatable
    belongs_to :product
  end
end
