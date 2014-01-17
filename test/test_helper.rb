# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'shopify_api'

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

module ShopifyJson
  def read_json(filename, root)
    contents = File.read(File.expand_path("../fixtures/shopify_json/#{filename}.json", __FILE__))
  end

  def product(filename)
    ShopifyAPI::Product.new(read_json(filename, "product"))
  end

  def variant(filename)
    ShopifyAPI::Variant.new(read_json(filename, "variant"))
  end
end
