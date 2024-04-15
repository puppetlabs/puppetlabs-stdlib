# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::deferrable_epp' do
  context 'call epp on non-deferred input' do
    let(:pre_condition) do
      'function epp($str, $data) { return "rendered"}'
    end

    it {
      expect(subject).to run.with_params('mymod/template.epp', { 'foo' => 'bar' }).and_return('rendered')
    }
  end

  context 'defers rendering with deferred input' do
    let(:pre_condition) do
      <<~END
        function epp($str, $data) { fail("should not have invoked epp()") }
        function find_template($str) { return "path" }
        function file($path) { return "foo: <%= foo %>" }
      END
    end

    it {
      foo = Puppet::Pops::Types::TypeFactory.deferred.create('join', [1, 2, 3])
      expect(subject).to run.with_params('mymod/template.epp', { 'foo' => foo }).and_return(kind_of(Puppet::Pops::Types::PuppetObject))
    }
  end

  context 'defers rendering with mixed deferred and undeferred input' do
    let(:pre_condition) do
      <<~END
        function epp($str, $data) { fail("should not have invoked epp()") }
        function find_template($str) { return "path" }
        function file($path) { return "foo: <%= foo %>, bar: <%= bar %>" }
      END
    end

    it {
      foo = Puppet::Pops::Types::TypeFactory.deferred.create('join', [1, 2, 3])
      expect(subject).to run.with_params('mymod/template.epp', { 'foo' => foo, 'bar' => 'xyz' }).and_return(kind_of(Puppet::Pops::Types::PuppetObject))
    }
  end

  context 'defers rendering with mixed deferred and undeferred input and preparse false' do
    let(:pre_condition) do
      <<~END
        function epp($str, $data) { fail("should not have invoked epp()") }
        function find_template($str) { return "path" }
        function file($path) { return "foo: <%= foo %>, bar: <%= bar %>" }
      END
    end

    it {
      foo = Puppet::Pops::Types::TypeFactory.deferred.create('join', [1, 2, 3])
      expect(subject).to run.with_params('mymod/template.epp', { 'foo' => foo, 'bar' => 'xyz' }, false).and_return(kind_of(Puppet::Pops::Types::PuppetObject))
    }
  end
end
