require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}
  Dir[Rails.root.join('spec/helpers/*.rb')].each {|f| require f}

  Capybara.default_driver = :terminus

  RSpec.configure do |config|
    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'

    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = false

    config.include FeatureHelpers, type: :feature

    config.before do
      DatabaseCleaner.strategy = :transaction
    end
    config.before(type: :feature) do
      DatabaseCleaner.strategy = :truncation
      Terminus.browser = :docked
    end
    config.before { DatabaseCleaner.start }

    config.after(type: :feature) do
      Terminus.return_to_dock
    end
    config.after do
      RubyCAS::Filter.fake(nil)
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  Terminus.start_phantomjs
end
