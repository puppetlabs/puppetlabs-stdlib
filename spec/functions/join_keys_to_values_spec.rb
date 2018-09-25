require 'spec_helper'

describe 'join_keys_to_values' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Takes exactly two arguments}) }
  it { is_expected.to run.with_params({}, '', '').and_raise_error(Puppet::ParseError, %r{Takes exactly two arguments}) }
  it { is_expected.to run.with_params('one', '').and_raise_error(TypeError, %r{The first argument must be a hash}) }
  it { is_expected.to run.with_params({}, 2).and_raise_error(TypeError, %r{The second argument must be a string}) }

  it { is_expected.to run.with_params({}, '').and_return([]) }
  it { is_expected.to run.with_params({}, ':').and_return([]) }
  it { is_expected.to run.with_params({ 'key' => 'value' }, '').and_return(['keyvalue']) }
  it { is_expected.to run.with_params({ 'key' => 'value' }, ':').and_return(['key:value']) }

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params({ 'ҝẽγ' => '√ạĺűē' }, ':').and_return(['ҝẽγ:√ạĺűē']) }
    it { is_expected.to run.with_params({ 'ҝẽγ' => '√ạĺűē' }, '万').and_return(['ҝẽγ万√ạĺűē']) }
  end

  it { is_expected.to run.with_params({ 'key' => nil }, ':').and_return(['key:']) }
  it 'runs join_keys_to_values(<hash with multiple keys>, ":") and return the proper array' do
    is_expected.to run.with_params({ 'key1' => 'value1', 'key2' => 'value2' }, ':').and_return(['key1:value1', 'key2:value2'])
  end

  it 'runs join_keys_to_values(<hash with array value>, " ") and return the proper array' do
    expected_result = ['key1 value1', 'key2 value2', 'key2 value3']
    is_expected.to run.with_params({ 'key1' => 'value1', 'key2' => ['value2', 'value3'] }, ' ').and_return(expected_result)
  end
end
