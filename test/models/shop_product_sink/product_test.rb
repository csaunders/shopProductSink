require 'test_helper'

module ShopProductSink
  class ProductTest < ActiveSupport::TestCase
    test 'that destroying product deletes all dependent variants and options' do
    	fake_product_id = 9
    	fake_product = ShopProductSink::Product.create(id: fake_product_id)
    	ShopProductSink::ProductVariant.create(product_id: fake_product_id)
    	ShopProductSink::Option.create(product_id: fake_product_id)

    	assert ShopProductSink::Product.count > 0, "should have at least one product fixture loaded"

    	variants = fake_product.product_variants
    	options = fake_product.options

    	assert variants.count > 0, "product fixture should have variants"
    	assert options.count > 0, "product fixture should have options"

      assert_difference "ShopProductSink::Product.count", -1 do
				fake_product.destroy
			end

			assert_equal 0, variants.reload.count, "variants count should be 0 after destroy"
			assert_equal 0, options.reload.count, "options count should be 0 after product destroy"
    end
  end
end
