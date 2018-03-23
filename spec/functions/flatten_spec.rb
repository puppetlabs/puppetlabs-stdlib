require 'spec_helper'

# rubocop:disable Style/WordArray, Layout/SpaceAfterComma
describe 'flatten' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params([], []).and_raise_error(Puppet::ParseError) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params([]).and_return([]) }
  it { is_expected.to run.with_params(['one']).and_return(['one']) }
  it { is_expected.to run.with_params([['one']]).and_return(['one']) }
  it { is_expected.to run.with_params(%w[a b c d e f g]).and_return(%w[a b c d e f g]) }
  it { is_expected.to run.with_params([['a', 'b', ['c', %w[d e], 'f', 'g']]]).and_return(%w[a b c d e f g]) }
  it { is_expected.to run.with_params(['ã', 'β', ['ĉ', %w[đ ẽ ƒ ġ]]]).and_return(%w[ã β ĉ đ ẽ ƒ ġ]) }

  context 'with deprecation warning' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params(['a', ['b', ['c']]]).and_return(['a','b','c'])
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params(['a', ['b', ['c']]]).and_return(['a','b','c'])
    end
  end
end
