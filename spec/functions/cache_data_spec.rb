require 'spec_helper'

describe 'cache_data' do
  let(:initial_data) { 'my_password' }
  let(:data_name) { 'mysql_password' }
  let(:cache_dir) { 'data_cache' }
  let(:filename) { "#{cache_dir}/#{data_name}" }

  it { expect(subject).not_to eq(nil) }
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(data_name).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('', initial_data).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(data_name, initial_data).and_return(initial_data) }

  context 'when data already exists' do
    before do
      File.stubs(:exists?).with(regexp_matches(/#{filename}/)).returns(true)
      File.expects(:read).with(regexp_matches(/#{filename}/)).returns(initial_data).once
    end

    it { is_expected.to run.with_params(data_name, initial_data).and_return(initial_data) }
  end

  context 'when a directory is supplied' do
    it { is_expected.to run.with_params(data_name, initial_data, 'mysql').and_return(initial_data) }
  end
end
