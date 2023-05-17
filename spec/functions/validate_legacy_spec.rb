# frozen_string_literal: true

require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'validate_legacy' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    describe 'when passing the type assertion' do
      it 'passes with a deprecation warning' do
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('deprecated')).once
        expect(scope).not_to receive(:function_validate_foo)
        expect(Puppet).not_to receive(:notice)
        expect(subject).to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when failing the type assertion' do
      it 'fails with a helpful message' do
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('deprecated')).once
        expect(scope).not_to receive(:function_validate_foo)
        expect(subject.func).to receive(:call_function).with('fail', 'validate_legacy(Integer, ...) expects an Integer value, got String').once
        expect(subject).to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when passing in undef' do
      it 'passes without failure' do
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('deprecated')).once
        expect(scope).not_to receive(:function_validate_foo)
        expect(Puppet).not_to receive(:notice)
        expect(subject).to run.with_params('Optional[Integer]', 'validate_foo', :undef)
      end
    end

    describe 'when passing in multiple arguments' do
      it 'passes with a deprecation message' do
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('deprecated')).once
        expect(scope).not_to receive(:function_validate_foo)
        expect(Puppet).not_to receive(:notice)
        expect(subject).to run.with_params('Optional[Integer]', 'validate_foo', :undef, 1, 'foo')
      end
    end
  end
end
