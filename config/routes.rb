ShopProductSink::Engine.routes.draw do
  post "/webhooks/process" => "webhooks#create"
end
