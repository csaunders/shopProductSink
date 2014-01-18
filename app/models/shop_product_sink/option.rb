module ShopProductSink
  class Option < ActiveRecord::Base
    include ApiCreatable
    belongs_to :product
  end
end
