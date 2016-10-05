module Spree
  module Reviewable
    extend ActiveSupport::Concern

    included do
      has_many :reviews
    end
  end
end
