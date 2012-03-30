dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# Don't want puppet getting the command line arguments for rake or autotest
ARGV.clear

require 'puppet'
require 'facter'
require 'mocha'
gem 'rspec', '>=2.0.0'
require 'rspec/expectations'

# So everyone else doesn't have to include this base constant.
module PuppetSpec
  FIXTURE_DIR = File.join(dir = File.expand_path(File.dirname(__FILE__)), "fixtures") unless defined?(FIXTURE_DIR)
end

require 'pathname'
require 'tmpdir'

require 'puppet_spec/verbose'
require 'puppet_spec/files'
require 'puppet_spec/fixtures'
require 'puppet_spec/matchers'
require 'monkey_patches/alias_should_to_must'
require 'monkey_patches/publicize_methods'

# JJM Hack to make the stdlib tests run in Puppet 2.6 (See puppet commit cf183534)
if not Puppet.constants.include? "Test" then
  module Puppet::Test
    class LogCollector
      def initialize(logs)
        @logs = logs
      end

      def <<(value)
        @logs << value
      end
    end
  end
  Puppet::Util::Log.newdesttype :log_collector do
    match "Puppet::Test::LogCollector"

    def initialize(messages)
      @messages = messages
    end

    def handle(msg)
      @messages << msg
    end
  end
end

Pathname.glob("#{dir}/shared_behaviours/**/*.rb") do |behaviour|
  require behaviour.relative_path_from(Pathname.new(dir))
end

RSpec.configure do |config|
  include PuppetSpec::Fixtures

  config.mock_with :mocha

  config.before :each do
    GC.disable


    # REVISIT: I think this conceals other bad tests, but I don't have time to
    # fully diagnose those right now.  When you read this, please come tell me
    # I suck for letting this float. --daniel 2011-04-21
    Signal.stubs(:trap)

    # We're using send because this is a private method to communicate it
    # should only be used for tests.  Puppet 2.6.x does not have the method.
    Puppet.settings.send(:initialize_everything_for_tests) unless Puppet.version =~ /^2\.6/


    @logs = []
    Puppet::Util::Log.newdestination(Puppet::Test::LogCollector.new(@logs))

    @log_level = Puppet::Util::Log.level
  end

  config.after :each do
    # We're using send because this is a private method to communicate it
    # should only be used for tests.  Puppet 2.6.x does not have the method.
    Puppet.settings.send(:clear_everything_for_tests) unless Puppet.version =~ /^2\.6/
    Puppet::Node::Environment.clear
    Puppet::Util::Storage.clear
    Puppet::Util::ExecutionStub.reset if Puppet::Util.constants.include? "ExecutionStub"

    PuppetSpec::Files.cleanup

    @logs.clear
    Puppet::Util::Log.close_all
    Puppet::Util::Log.level = @log_level

    GC.enable
  end
end
