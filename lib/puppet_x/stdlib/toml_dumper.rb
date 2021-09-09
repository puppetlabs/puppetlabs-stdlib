# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'puppet_x/stdlib'
require 'date'

module PuppetX::Stdlib
  # The Dumper class was blindly copied from https://github.com/emancu/toml-rb/blob/v2.0.1/lib/toml-rb/dumper.rb
  # This allows us to use the `to_toml` function as a `Deferred` function because the `toml-rb` gem is usually
  # installed on the agent and the `Deferred` function gets evaluated before the catalog gets applied. This
  # makes it in most scenarios impossible to install the gem before it is used.
  class TomlDumper
    attr_reader :toml_str

    def initialize(hash)
      @toml_str = ''

      visit(hash, [])
    end

    private

    def visit(hash, prefix, extra_brackets = false)
      simple_pairs, nested_pairs, table_array_pairs = sort_pairs hash

      if prefix.any? && (simple_pairs.any? || hash.empty?)
        print_prefix prefix, extra_brackets
      end

      dump_pairs simple_pairs, nested_pairs, table_array_pairs, prefix
    end

    def sort_pairs(hash)
      nested_pairs = []
      simple_pairs = []
      table_array_pairs = []

      hash.keys.sort.each do |key|
        val = hash[key]
        element = [key, val]

        if val.is_a? Hash
          nested_pairs << element
        elsif val.is_a?(Array) && val.first.is_a?(Hash)
          table_array_pairs << element
        else
          simple_pairs << element
        end
      end

      [simple_pairs, nested_pairs, table_array_pairs]
    end

    def dump_pairs(simple, nested, table_array, prefix = [])
      # First add simple pairs, under the prefix
      dump_simple_pairs simple
      dump_nested_pairs nested, prefix
      dump_table_array_pairs table_array, prefix
    end

    def dump_simple_pairs(simple_pairs)
      simple_pairs.each do |key, val|
        key = quote_key(key) unless bare_key? key
        @toml_str << "#{key} = #{to_toml(val)}\n"
      end
    end

    def dump_nested_pairs(nested_pairs, prefix)
      nested_pairs.each do |key, val|
        key = quote_key(key) unless bare_key? key

        visit val, prefix + [key], false
      end
    end

    def dump_table_array_pairs(table_array_pairs, prefix)
      table_array_pairs.each do |key, val|
        key = quote_key(key) unless bare_key? key
        aux_prefix = prefix + [key]

        val.each do |child|
          print_prefix aux_prefix, true
          args = sort_pairs(child) << aux_prefix

          dump_pairs(*args)
        end
      end
    end

    def print_prefix(prefix, extra_brackets = false)
      new_prefix = prefix.join('.')
      new_prefix = '[' + new_prefix + ']' if extra_brackets

      @toml_str += "[" + new_prefix + "]\n" # rubocop:disable Style/StringLiterals
    end

    def to_toml(obj)
      if obj.is_a?(Time) || obj.is_a?(DateTime)
        obj.strftime('%Y-%m-%dT%H:%M:%SZ')
      elsif obj.is_a?(Date)
        obj.strftime('%Y-%m-%d')
      elsif obj.is_a? Regexp
        obj.inspect.inspect
      elsif obj.is_a? String
        obj.inspect.gsub(/\\(#[$@{])/, '\1') # rubocop:disable Style/RegexpLiteral
      else
        obj.inspect
      end
    end

    def bare_key?(key)
      # rubocop:disable Style/RegexpLiteral
      !!key.to_s.match(/^[a-zA-Z0-9_-]*$/)
      # rubocop:enable Style/RegexpLiteral
    end

    def quote_key(key)
      '"' + key.gsub('"', '\\"') + '"'
    end
  end
end
