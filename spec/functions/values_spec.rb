require 'spec_helper'

describe 'values' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) } if Puppet.version < '5.5.0'
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params({}, 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) } if Puppet.version < '5.5.0'
  it { is_expected.to run.with_params({}).and_return([]) }
  it { is_expected.to run.with_params('key' => 'value').and_return(['value']) }

  if Puppet.version < '5.5.0'
    it 'returns the array of values' do
      result = subject.call([{ 'key1' => 'value1', 'key2' => 'value2', 'duplicate_value_key' => 'value2' }])
      expect(result).to match_array(%w[value1 value2 value2])
    end
    it 'runs with UTF8 and double byte characters' do
      result = subject.call([{ 'かぎ' => '使用', 'ҝĕұ' => '√ẩŀứệ', 'ҝĕұďŭрļǐçằťè' => '√ẩŀứệ' }])
      expect(result).to match_array(['使用', '√ẩŀứệ', '√ẩŀứệ'])
    end
  end

  context 'with deprecation warning' do
    after(:each) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'displays a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params('key' => 'value').and_return(['value'])
    end
    it 'displays no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = 'false'
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params('key' => 'value').and_return(['value'])
    end
  end
end
