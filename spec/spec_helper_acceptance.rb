#! /usr/bin/env ruby -S rspec
require 'beaker-rspec'

UNSUPPORTED_PLATFORMS = []

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  # This will install the latest available package on el and deb based
  # systems fail on windows and osx, and install via gem on other *nixes
  foss_opts = { :default_action => 'gem_install' }

  if default.is_pe?; then install_pe; else install_puppet( foss_opts ); end

  hosts.each do |host|
    on host, "mkdir -p #{host['distmoduledir']}"
    on host, "/bin/touch #{host['puppetpath']}/hiera.yaml"
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    if ENV['FUTURE_PARSER'] == 'true'
      default[:default_apply_opts] ||= {}
      default[:default_apply_opts].merge!({:parser => 'future'})
    end
    hosts.each do |host|
      if host['platform'] !~ /windows/i
        copy_root_module_to(host, :source => proj_root, :module_name => 'stdlib')
      end

    end
    hosts.each do |host|
      if host['platform'] =~ /windows/i
        on host, puppet('plugin download')
      end
    end
  end
end

def is_future_parser_enabled?
  if default[:default_apply_opts]
    return default[:default_apply_opts][:parser] == 'future'
  end
  return false
end
