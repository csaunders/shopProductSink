# ShopProductSink

[![Build Status](https://travis-ci.org/csaunders/shopProductSink.png?branch=master)](https://travis-ci.org/csaunders/shopProductSink)

**Note: This project is currently under development!**

Reduce those unnecessary API calls!!

ShopifyProductSink is a Rails engine to simplify working with
Shopify by keeping a shops products synchronized with a local copy.

## Features

1. Provides functionality to import products from Shopify
2. Provides an import helper which can do all the heavy lifting of pulling in products
3. Provides a simple way to register webhooks for product changes
4. Provides a module that can be included to take care of all the "boring" parts of webhook verification

## Wanted Features / Todo List

1. Provide a default webhooks controller that will do basic product synchronization
2. Do proper shop scoping since right now there isn't any and there could possibly be some data leakage
3. Refactor API createable integration objects such that them and their migrations aren't imported when the engine is installed
4. Remove all CSS and JavaScript since it's not actually needed for this engine to work whatsoever

## Setup

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
rake shop_product_sink:install:migrations
rake db:migrate SCOPE=shop_product_sink
```

### Shop Scoping

Add shop scoping to your products in a couple of steps. You'll need a `Shop` model, which can be looked up by the shop's myshopify.com domain.

**1. Add a `has_many :products` association to your shop model**

```ruby
# app/models/shop.rb
class Shop < ActiveRecord::Base
  has_many :products, class_name: 'ShopProductSink::Product'
end
```
Note: the `class_name` must be set to the engine's Product model.

**2. Set the shop class name in an initializer**

```ruby
# config/initializers/shop_product_sink.rb
# Set the model that ShopProductSink::Product will belong to
ShopProductSink.shop_class = 'Shop'
```
This will set the belongs_to relation for `ShopProductSink::Product`. Set it as a string.

**3. Let the `ShopProductSink` know how to find
a single shop based on its shopify domain**

By default, `ShopProductSink` will look up the shop using your `Shop` model's `find_by_domain` method. So, if your Shop model has a `domain` attribute that corresponds to the Shop's myshopify domain (e.g., *bagelshop.myshopify.com*), then you're set. 

Otherwise, you'll need to add your own method to look up a shop by its myshopify.com domain:

```ruby
# app/models/shop.rb
def self.find_by_shop_domain(shop_domain)
  self.where(myshopify_domain: shop_domain).first
end
```
```ruby
# config/initializers/shop_product_sink.rb
# Set the method within shop_class above to lookup a shop by its myshopify.com domain
ShopProductSink.shop_lookup_method = :find_by_shop_domain
```

#### Upgrading an existing install to use shop scoping
If you're already using `ShopProductSink` in a current app, repeat the "Install and Run migrations" step above to add a `shop_id` column to the `shop_product_sink_products` table.

## Usage

The engine comes with two utility functions that make it easier to integrate
product synchronization into your app.

### 1. Product Importer

```ruby
# Partner App Initialization
importer = ShopProductSink::Importers::Product.new(
  shop: 'yourshop.myshopify.com',
  token: 'abracadabra'
)
importer.import

# Alternative -- Private App Initialization
importer = ShopProductSink::Importers::Product.new(
  site: 'https://apikey:password@yourshop.myshopify.com/admin'
)
importer.import
```

### 2. Product Synchronization via Webhooks w/ShopProductSink::WebhooksController

Secondly it comes with a utility to make registering webhooks easier. There are a few catches if you want to have
it be more automated. There are routes setup for an included Webhooks Controller that you can leverage if you don't
want to handle validating webhooks on your own.

**1. Setup your applications default host**

```ruby
# application.rb
Rails.application.routes.default_url_options[:host] = "your.domain.tld"
```

**2. Include your Application Secret in your ENV**

You should probably be doing this already anyway since it's good practice. The only problem
is you are somewhat forced onto a naming convention for at least one of your API variables.

The variable that needs to be set in your environment is `SHOPIFY_APP_SECRET`

**3. Register to receive Product change webhooks whenever it is necessary**

```ruby
ShopProductSink::WebhookRegistration.register(
  shop: 'yourshop.myshopify.com',
  token: 'abracadabra'
)
```

### I don't want to use your WebhooksController because XYZ

You don't have to!!! If you want you can create your own webhooks handler.

You are required to do a few things if you use your own webhooks controller/handler:

1. Include the `ShopProductSink::Webhooks` module in it.
2. Implement `application_secret`
