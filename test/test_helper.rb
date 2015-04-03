# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shopify_api'
require 'pry'
require 'pry-byebug'
require 'mocha/mini_test'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ShopProductSink::UnitTest < ActiveSupport::TestCase
  def setup
    ShopifyAPI::Base.site = "https://fakeshop.myshopify.com/admin"
    additional_setup
  end

  def additional_setup
  end

  def teardown
    ShopifyAPI::Base.site = nil
  end
end

def product_and_relations_difference
  ["Product", "ProductVariant", "Option"].map { |model|
    "ShopProductSink::#{ model }.count"
  }
end

module ShopifyJson
  def self.read_file(filename)
    File.read(File.expand_path("../fixtures/shopify_json/#{filename}.json", __FILE__))
  end

  def self.read_full_json(filename)
    contents = read_file(filename)
    ActiveSupport::JSON.decode(contents)
  end

  def self.read_json(filename, root)
    read_full_json(filename)[root]
  end

  def self.product(filename)
    ShopifyAPI::Product.new(read_json(filename, "product"))
  end

  def self.variant(filename)
    ShopifyAPI::Variant.new(read_json(filename, "variant"))
  end
end
