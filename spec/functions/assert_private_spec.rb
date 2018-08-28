require 'spec_helper'

describe 'assert_private' do
  context 'when called from inside module' do
    it 'does not fail' do
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('foo')

      is_expected.to run.with_params
    end
  end

  context 'when called from private class' do
    it 'fails with a class error message' do
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('hostclass')

      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Class foo::baz is private})
    end

    it 'fails with an explicit failure message' do
      is_expected.to run.with_params('failure message!').and_raise_error(Puppet::ParseError, %r{failure message!})
    end
  end

  context 'when called from private definition' do
    it 'fails with a class error message' do
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('definition')

      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Definition foo::baz is private})
    end
  end
end
