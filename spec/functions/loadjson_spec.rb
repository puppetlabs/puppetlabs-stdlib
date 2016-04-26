require 'spec_helper'

describe 'loadjson' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /wrong number of arguments/i) }

  context 'when a non-existing file is specified' do
    let(:filename) { '/tmp/doesnotexist' }
    before {
      File.expects(:exists?).with(filename).returns(false).once
      PSON.expects(:load).never
    }
    it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
  end

  context 'when an existing file is specified' do
    let(:filename) { '/tmp/doesexist' }
    let(:data) { { 'key' => 'value' } }
    let(:json) { '{"key":"value"}' }
    before {
      File.expects(:exists?).with(filename).returns(true).once
      File.expects(:read).with(filename).returns(json).once
      PSON.expects(:load).with(json).returns(data).once
    }
    it { is_expected.to run.with_params(filename).and_return(data) }
  end

  context 'when the file could not be parsed' do
    let(:filename) { '/tmp/doesexist' }
    let(:json) { '{"key":"value"}' }
    before {
      File.expects(:exists?).with(filename).returns(true).once
      File.expects(:read).with(filename).returns(json).once
      PSON.stubs(:load).with(json).once.raises StandardError, 'Something terrible have happened!'
    }
    it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
  end
end
