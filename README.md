# ShopProductSink

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
# Install just the product sink migrations
rake shop_product_sink:install:migrations

# Not care and run migrations for whatever engines you have installed
rake railties:install:migrations

# Actually run the migrations on your database
rake db:migrate SCOPE=shop_product_sink
```

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

**2. In an initializer let the `ShopProductSink::WebhooksController` know how to find
a single shop based on it's shopify domain**

```ruby
# config/initializers/shop_product_sink.rb
ShopProductSink::WebhooksController.shop_retrieval_strategy = -> (shopify_domain) {
  Shop.where(domain: shopify_domain).first
}
```

**3. Include your Application Secret in your ENV**

You should probably be doing this already anyway since it's good practice. The only problem
is you are somewhat forced onto a naming convention for at least one of your API variables.

The variable that needs to be set in your environment is `SHOPIFY_API_SECRET`

**4. Register to receive Product change webhooks whenever it is necessary**

```ruby
ShopProductSink::WebhookRegistration.register(
  shop: 'yourshop.myshopify.com',
  token: 'abracadabra'
)
```

### I don't want to use your WebhooksController because XYZ

You don't have to!!!

If you want you can create your own webhooks handler and just include the `ShopProductSink::Webhooks` module in it.

You are required to do a few things if you use this:

1. Set the `shop_retrieval_strategy`
2. Implement `application_secret`
