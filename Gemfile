#
# This Gemfile results in a ruby environment within which
# rspec tests pass.  Use bundler like this:
#
#  bundle install --path vendor
#
source "http://rubygems.org"

ruby "1.8.7"
# puppet 2.7.19 did not have a required fix: a7d6c3df055e0721217d0781c67294ecf816138b
# xref: http://projects.puppetlabs.com/issues/show/11325
gem "puppet", ">= 2.7", "< 3.0", :git => "https://github.com/puppetlabs/puppet", :branch => "2.7.x"
# rspec-puppet 0.1.4 also was missing a needed patch, so pull HEAD to get it
gem "rspec-puppet", "0.1.4", :git => "https://github.com/rodjek/rspec-puppet", :branch => "master"
gem "mocha", "= 0.10.5"
gem "puppetlabs_spec_helper"
gem "puppet-lint"
gem "rake"
gem "rspec", ">= 2.10", "< 2.11"
