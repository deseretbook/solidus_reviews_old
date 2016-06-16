require 'sass/rails'
require 'solidus_core'
require 'solidus_reviews/engine'
require 'solidus_reviews/version'
require 'coffee_script'

module Spree
  module Reviews
    module_function

    def config(*)
      yield(Spree::Reviews::Config)
    end
  end
end
