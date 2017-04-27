lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'solidus_reviews/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_reviews'
  s.version     = '2.1'
  s.summary     = 'Basic review and ratings facility for Spree'
  s.description = s.summary
  s.required_ruby_version = '>= 2.3.1'

  s.authors = ['Paul Callaghan, dgra']
  s.email        = 'webdev@deseretbook.com'
  s.license      = 'BSD-3'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency "solidus", ['>= 1.0', '< 3']
  s.add_dependency 'deface'

  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry-rails'
end
