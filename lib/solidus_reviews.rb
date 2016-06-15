require 'sass/rails'
require 'solidus_core'
require 'solidus_reviews/engine'
require 'solidus_reviews/version'
require 'coffee_script'

module Solidus
  module Reviews
    module_function

    def config(*)
      yield(Solidus::Reviews::Config)
    end
  end
end
