#!/usr/bin/env ruby
# vim: set sw=2 sts=2 et tw=80 :
require 'rspec'
require 'pry'

#XXX Super ugly hack to keep from starting beaker nodes
module Kernel
  # make an alias of the original require
  alias_method :original_require, :require
  # rewrite require
  def require name
    original_require name if name != 'spec_helper_acceptance'
  end
end
UNSUPPORTED_PLATFORMS = []
def fact(*args) [] end
#XXX End hax

# Get a list of functions for test coverage
function_list = Dir[File.join(File.dirname(__FILE__),"..","..","lib","puppet","parser","functions","*.rb")].collect do |function_rb|
  File.basename(function_rb,".rb")
end

## Configure rspec to parse tests
options = RSpec::Core::ConfigurationOptions.new(['spec/acceptance'])
configuration = RSpec::configuration
world = RSpec::world
options.parse_options
options.configure(configuration)
configuration.load_spec_files

## Collect up tests and example groups into a hash
def get_tests(children)
  children.inject({}) do |memo,c|
    memo[c.description] = Hash.new
    memo[c.description]["groups"] = get_tests(c.children) unless c.children.empty?
    memo[c.description]["tests"] = c.examples.collect { |e|
      e.description unless e.pending?
    }.compact unless c.examples.empty?
    memo[c.description]["pending_tests"] = c.examples.collect { |e|
      e.description if e.pending?
    }.compact unless c.examples.empty?
    memo
  end
end

# Convert tests hash to csv format
def to_csv(function_list,tests)
  function_list.collect do |function_name|
    if v = tests["#{function_name} function"]
      positive_tests = v["groups"]["success"] ? v["groups"]["success"]["tests"].length : 0
      negative_tests = v["groups"]["failure"] ? v["groups"]["failure"]["tests"].length : 0
      pending_tests  =
        (v["groups"]["failure"] ? v["groups"]["success"]["pending_tests"].length : 0) +
        (v["groups"]["failure"] ? v["groups"]["failure"]["pending_tests"].length : 0)
    else
      positive_tests = 0
      negative_tests = 0
      pending_tests  = 0
    end
    sprintf("%-25s, %-9d, %-9d, %-9d", function_name,positive_tests,negative_tests,pending_tests)
  end.compact
end

tests = get_tests(world.example_groups)
csv = to_csv(function_list,tests)
percentage_tested = "#{tests.count*100/function_list.count}%"
printf("%-25s,  %-9s, %-9s, %-9s\n","#{percentage_tested} have tests.","Positive","Negative","Pending")
puts csv
