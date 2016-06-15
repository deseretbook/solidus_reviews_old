module SolidusReviews
  class Engine < Rails::Engine
    require 'solidus/core'
    isolate_namespace Spree
    engine_name 'solidus_reviews'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'spree.reviews.environment', before: :load_config_initializers do
      Spree::Reviews::Config = Spree::ReviewSetting.new
    end

    def self.activate
      cache_klasses = %W(#{config.root}/app/**/*_decorator*.rb #{config.root}/app/overrides/*.rb)
      Dir.glob(cache_klasses) do |klass|
        Rails.configuration.cache_classes ? require(klass) : load(klass)
      end
      Spree::Ability.register_ability(Spree::ReviewsAbility)
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
