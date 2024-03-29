source 'https://rubygems.org'

# Scaffolding
gem 'rails', '5.2.4.3'
# # Use passenger as the web server
gem 'passenger', "~>6.0.6"
# Puma time
gem "puma"
gem "puma-status"
# # It forces to use a specific version of Rake
gem "rake", "13.0.3"
gem "nokogiri", ">= 1.5.6"
# # Nice CLI progress bar for ruby
gem "progressbar", "~>0.21.0"

# # Database
gem 'mysql2', '~>0.4.4'
# # Having problem with new migrations?
# # * Disable slim_scrooge here
# # * Deploy on server with "cap deploy:migrations"
# # * Restore slim_scrooge here
# # * Deploy again on server with "cap deploy"
# # Removed slim_scrooge by now
# # Optimizator query
# #gem 'slim_scrooge'

# # Middleware
gem 'rack-cors', "~>1.1.1"
gem 'rack-proxy', "~>0.7.0"

# # for Users and authentication
gem 'devise',    "~>4.7.3"
gem 'humanizer', "~>2.6.3"
gem 'cancancan', "~>3.1.0"
gem 'rolify',    "~>5.1.0"
gem 'recaptcha', "~>4.9.0"

# # Presentation Related gems
gem 'json'
# # Use HAML instead of ERB
gem 'haml-rails', "~>2.0.1"
# # new styles
gem 'will_paginate-bootstrap', "~>1.0.2"
# # for easy pagination
gem 'will_paginate', "~>3.3.0"
# # experimental
gem "alphabetical_paginate", :git => "git://github.com/dej611/alphabetical_paginate.git"
# # iconv for utf-8 to latin1 conversion
gem 'iconv', "~>1.0.4"
# # Bootstrap gem
gem "autoprefixer-rails", "~>6.4.0"
gem 'bootstrap-sass', "~> 3.4.1"
# # Some more icons
gem 'font-awesome-sass', "~> 4.2.0"
# # sass support: it should be out of the assets group!
gem 'sass-rails', '~>5.0.0'
# # Use Twitter Typeahead
gem 'twitter-typeahead-rails', "~>0.10.5"

# # Js libs
# # jQuery
gem 'jquery-rails', "~>4.4.0"
# # jQuery UI
gem 'jquery-ui-rails', "~>5.0.0"
# # Add Modernizr to dynamically run HTML5 checks and load JS polyfills conditionally
gem 'modernizr-rails', "~>2.7.1"
# d3js gem -> takes care about updating the JS file
gem 'd3-rails', "~>3.4.11"
# leaflet gem
gem 'leaflet-rails', "~>0.7.3"
# async.js gem
gem 'async-rails', "~>0.9.0"
# replacement for native alert and confirm dialogs
gem 'bootbox-rails', '~>0.4'
# Advances Editor for Property descriptions
gem 'tinymce-rails', '~>4.3.8'

# No need for coffeescript here, JS it's enough
gem "uglifier", "~>2.5.3"

group :deploy do
  # # Deploy with Capistrano
  gem 'capistrano', "~>2.15.4"
  # gem 'capistrano-multiyaml'
  gem "capistrano-ext", "~>1.2.1"
  gem 'capistrano-rbenv', "~>1.0.5"
  # # Comment this line if you are not using RVM
  # # Starting with RVM 1.11.3 Capistrano integration was extracted to a separate gem.
  # # See https://rvm.io/integration/capistrano/
  # gem 'rvm-capistrano', "~>1.5.4"
end

gem "handlebars_assets", "~>0.23.8"

# Forum gem
# gem 'forum_monster', :git => 'https://github.com/dej611/forum_monster.git'
# gem 'bb-ruby'

gem 'net-ssh', "~>5.2.0"
gem 'net-scp', "~>2.0.0"
gem 'ed25519', "~>1.2"
gem 'bcrypt_pbkdf', "~>1.0.0"

# # Debugger and webapp profiling
gem "newrelic_rpm", "~>4.0.0"
gem "rollbar", "~>2.26.1"

# Pure Ruby library to use R language from Ruby code
# it needs that R interpreter is installed and R_HOME is configured
# see https://sites.google.com/a/ddahl.org/rinruby-users/Home for
# more documentation
# Grouped because of Travis-CI
# group :production, :development do
#   gem 'rinruby'
# end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test, :development do

  # Use Thin as web server
  gem "thin", "~>1.6.2"

  # Disable for the moment
  # gem "spork-rails"

  gem 'rspec-rails', '~> 4.0.0'
  gem 'rspec-collection_matchers', '~> 1.2.0'
  gem 'rspec-activemodel-mocks', '~> 1.1.0'
  gem 'shoulda-matchers', "~>4.3.0"
  gem 'rails-controller-testing'
  # gem 'rspec_rails3_validation_expectations', '0.0.2', :git => 'https://github.com/bosh/rspec_rails3_validation_expectations.git'

  gem "cucumber", "~> 1.1.0"

  # Due to the new name resolution approach of the bundler gem it has the require option
  gem 'cucumber-rails', :require => false
  gem 'capybara', "~>3.33.0"
  gem 'launchy', "~>2.5.0"
  gem 'database_cleaner-active_record'
  gem 'factory_girl_rails', "~> 4.9.0"

  # # Query Tracer: useful to debug
  # # Do not activate unless you really need it!
  # # When active it fills all your memory!
  # gem "active_record_query_trace"

  # # Used to test with a real browser
  gem "selenium", "~>0.2.11"
  gem "selenium-webdriver", "~>2.53.4"
  gem "selenium-client", "~>1.2.18"
  # # In this case the browser is phantomjs
  # gem 'poltergeist'
  # gem 'phantomjs', :require => 'phantomjs/poltergeist'

  # # Metrics, metrics, metrics...
  gem 'brakeman', "~>4.8.2"
  gem 'ruby-prof', "~>1.4.1"
  gem 'metric_fu', "~>4.13.0"
  gem 'rails_best_practices', "~>1.20.0"
  gem 'simplecov', '~> 0.18.5', :require => false

end

group :development do
  gem 'pry'
  gem 'pry-byebug', :platform => :ruby_20
  gem 'awesome_print', require:'ap'
  gem 'meta_request'
end

gem 'redcarpet'
