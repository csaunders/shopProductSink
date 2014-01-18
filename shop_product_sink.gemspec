$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shop_product_sink/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shop_product_sink"
  s.version     = ShopProductSink::VERSION
  s.authors     = ["Christopher Saunders"]
  s.email       = ["csaunders@shopify.com"]
  s.homepage    = "TODO"
  s.summary     = "Tool to help reduce API requests by easily providing a cache"
  s.description = "Shop Product Sink is designed to make it easier to keep a local cache of all the product information for shops using your application"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  # s.add_dependency "rails-bigint-pk"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shopify_api"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-debugger"
end
