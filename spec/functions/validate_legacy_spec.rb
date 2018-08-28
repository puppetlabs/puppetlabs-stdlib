require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'validate_legacy' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    describe 'when passing the type assertion and passing the previous validation' do
      it 'passes without notice' do
        expect(scope).to receive(:function_validate_foo).with([5]).once
        expect(Puppet).to receive(:notice).never
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when passing the type assertion and failing the previous validation' do
      it 'passes with a notice about newly accepted value' do
        expect(scope).to receive(:function_validate_foo).with([5]).and_raise(Puppet::ParseError, 'foo').once
        expect(Puppet).to receive(:notice).with(include('Accepting previously invalid value for target type'))
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when failing the type assertion and passing the previous validation' do
      it 'passes with a deprecation message' do
        expect(scope).to receive(:function_validate_foo).with(['5']).once
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('Integer')).once
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when failing the type assertion and failing the previous validation' do
      it 'fails with a helpful message' do
        expect(scope).to receive(:function_validate_foo).with(['5']).and_raise(Puppet::ParseError, 'foo').once
        expect(subject.func).to receive(:call_function).with('fail', include('Integer')).once
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when passing in undef' do
      it 'works' do
        expect(scope).to receive(:function_validate_foo).with([:undef]).once
        expect(Puppet).to receive(:notice).never
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef)
      end
    end

    describe 'when passing in multiple arguments' do
      it 'passes with a deprecation message' do
        expect(scope).to receive(:function_validate_foo).with([:undef, 1, 'foo']).once
        expect(Puppet).to receive(:notice).never
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef, 1, 'foo')
      end
    end
  end
end
