source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'react-rails'
gem 'rest-client'
gem 'sprockets-coffee-react'
gem 'paperclip'
gem 'aws-sdk', '< 2.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-exif-js'
  gem 'rails-assets-fabric'
  gem 'rails-assets-webcamjs'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'passenger'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
