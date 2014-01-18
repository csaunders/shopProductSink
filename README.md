# ShopProductSink

**Note: This project is currently under development!**

Reduce those unnecessary API calls!!

ShopifyProductSink is a Rails engine to simplify working with
Shopify by keeping a shops products synchronized with a local copy.

# Features

1. Provides functionality to import products from Shopify

# Wanted Features / Todo List

1. Provide an import helper which can do all the heavy lifting of pulling in products
2. Provide a way to register for webhooks for product and variant update/creation/deletion
3. Do proper shop scoping since right now there isn't any and there could possibly be some data leakage

# Setup

Right now [I have no idea what I'm doing](https://i.chzbgr.com/maxW500/5836571648/hD263FFD6/) when it comes to engines,
so I'm just speccing the docs based on the [hooking into an application section on the Rails Guides](http://edgeguides.rubyonrails.org/engines.html#hooking-into-an-application)

Until I get a rubygem setup you'll need to link right to the github repository in your
Gemfile:

```
gem 'shop_product_sink', git: 'https://github.com/csaunders/shopProductSink'
```

Mount the application in your routes file:

```
mount ShopProductSink::Engine, at: "product_sink"
```

Install and Run the migrations:

```
# Install just the product sink migrations
rake shop_product_sink:install:migrations

# Not care and run migrations for whatever engines you have installed
rake railties:install:migrations

# Actually run the migrations on your database
rake db:migrate SCOPE=shop_product_sink
```

# Usage

Because the engine doesn't provide any easily pluggable functionality yet importing will
still need to be done manually when fetching the products from the Shopify API.

```ruby
# Assuming Private App
# For other kinds of apps see -- https://github.com/Shopify/shopify_api
ShopifyAPI::Base.site = "https://api_key:password@someshop.myshopify.com/admin"

# Grab the first 250 products, if there's more you'll need to paginate
api_products = ShopifyAPI::Product.find(:all)

# Extract and save those products and variants to the Database
db_products = ShopProductSink::Product.create_from_resources(products)
```
