require 'spec_helper'

describe 'join' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) } if Puppet.version < '5.5.0'
  it {
    pending('Current implementation ignores parameters after the second.')
    is_expected.to run.with_params([], '', '').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Requires array to work with}) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params([], 2).and_raise_error(Puppet::ParseError, %r{Requires string to work with}) } if Puppet.version < '5.5.0'

  it { is_expected.to run.with_params([]).and_return('') }
  it { is_expected.to run.with_params([], ':').and_return('') }
  it { is_expected.to run.with_params(['one']).and_return('one') }
  it { is_expected.to run.with_params(['one'], ':').and_return('one') }
  it { is_expected.to run.with_params(%w[one two three]).and_return('onetwothree') }
  it { is_expected.to run.with_params(%w[one two three], ':').and_return('one:two:three') }
  it { is_expected.to run.with_params(%w[ōŋể ŧשợ ţђŕẽё], ':').and_return('ōŋể:ŧשợ:ţђŕẽё') }

  context 'with deprecation warning' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params([]).and_return('')
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params([]).and_return('')
    end
  end
end
