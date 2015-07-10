#! /usr/bin/env ruby -S rspec
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

UNSUPPORTED_PLATFORMS = []

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    if ENV['FUTURE_PARSER'] == 'yes'
      default[:default_apply_opts] ||= {}
      default[:default_apply_opts].merge!({:parser => 'future'})
    end

    copy_root_module_to(default, :source => proj_root, :module_name => 'stdlib')
  end
end

def is_future_parser_enabled?
  if default[:type] == 'aio'
    return true
  elsif default[:default_apply_opts]
    return default[:default_apply_opts][:parser] == 'future'
  end
  return false
end
