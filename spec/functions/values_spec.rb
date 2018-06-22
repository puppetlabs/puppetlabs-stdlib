require 'spec_helper'

describe 'values', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params({}, 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }
  it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Requires hash to work with}) }
  it { is_expected.to run.with_params({}).and_return([]) }
  it { is_expected.to run.with_params('key' => 'value').and_return(['value']) }
  it 'returns the array of values' do
    result = subject.call([{ 'key1' => 'value1', 'key2' => 'value2', 'duplicate_value_key' => 'value2' }])
    expect(result).to match_array(['value1', 'value2', 'value2'])
  end

  it 'runs with UTF8 and double byte characters' do
    result = subject.call([{ 'かぎ' => '使用', 'ҝĕұ' => '√ẩŀứệ', 'ҝĕұďŭрļǐçằťè' => '√ẩŀứệ' }])
    expect(result).to match_array(['使用', '√ẩŀứệ', '√ẩŀứệ'])
  end
end
