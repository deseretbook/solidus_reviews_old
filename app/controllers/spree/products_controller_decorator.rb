Spree::ProductsController.class_eval do
  helper Spree::ReviewsHelper

  reviews_fields = %i[avg_rating reviews_count]
  reviews_fields.each {|attrib| Spree::PermittedAttributes.product_attributes << attrib }

  Spree::Api::ApiHelpers.class_eval do
    reviews_fields.each {|attrib| class_variable_set(:@@product_attributes, class_variable_get(:@@product_attributes).push(attrib)) }
  end
end
