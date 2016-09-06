require 'spec_helper'

if Puppet.version.to_f >= 4.0
  describe 'validate_legacy' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    describe 'when passing the type assertion and passing the previous validation' do
      before do
        scope.expects(:function_validate_foo).with([5]).once
        Puppet.expects(:notice).never
      end
      it 'passes without notice' do
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when passing the type assertion and failing the previous validation' do
      before do
        scope.expects(:function_validate_foo).with([5]).raises(Puppet::ParseError, 'foo').once
        Puppet.expects(:notice).with(includes('Accepting previously invalid value for target type'))
      end
      it 'passes with a notice about newly accepted value' do
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when failing the type assertion and passing the previous validation' do
      before do
        scope.expects(:function_validate_foo).with(['5']).once
        subject.func.expects(:call_function).with('deprecation', 'validate_legacy', includes('expected an Integer value')).once
      end
      it 'passes with a deprecation message' do
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when failing the type assertion and failing the previous validation' do
      before do
        scope.expects(:function_validate_foo).with(['5']).raises(Puppet::ParseError, 'foo').once
        subject.func.expects(:call_function).with('fail', includes('expected an Integer value')).once
      end
      it 'fails with a helpful message' do
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when passing in undef' do
      before do
        scope.expects(:function_validate_foo).with([:undef]).once
        Puppet.expects(:notice).never
      end
      it 'works' do
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef)
      end
    end

    describe 'when passing in multiple arguments' do
      before do
        scope.expects(:function_validate_foo).with([:undef, 1, 'foo']).once
        Puppet.expects(:notice).never
      end
      it 'passes with a deprecation message' do
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef, 1, 'foo')
      end
    end
  end
end
