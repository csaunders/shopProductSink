Rails.application.routes.draw do

  mount ShopProductSink::Engine => "/shop_product_sink"
end
