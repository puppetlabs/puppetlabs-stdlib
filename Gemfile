source "https://rubygems.org"

group :development do
  gem 'watchr'
end

group :development, :test do
  gem 'rake'
  gem 'puppetmodule-stdlib', ">= 1.0.0", :path => File.expand_path("..", __FILE__)
  gem 'rspec', "~> 2.11.0", :require => false
  gem 'mocha', "~> 0.10.5", :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-puppet', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
