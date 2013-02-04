source 'https://rubygems.org'

gem 'rails', '~> 3.2.11'
gem 'foreman'
gem 'thin'
gem 'pg'

gem 'jquery-rails'
gem 'backbone-rails'

gem 'rubycas-client-rails', git: 'git://github.com/rubycas/rubycas-client-rails'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'travis'

  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'guard'
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'guard-spork', git: 'git://github.com/guard/guard-spork.git'
  gem 'guard-rspec'
end

group :test, :development do
  gem 'rake'

  gem 'rspec-rails', '>= 2.0.0'
  gem 'spork'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'terminus'
  gem 'jasmine'
  gem 'guard-jasmine'
  gem 'jasminerice'
end
