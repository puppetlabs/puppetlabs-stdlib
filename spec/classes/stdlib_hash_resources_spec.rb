require 'spec_helper'

describe 'stdlib::hash_resources' do
  let(:params) do {
    :resources => {
      'file' => {
        '/tmp/foo' => {'ensure'=> 'present', 'content'=> 'foo'},
        '/tmp/bar' => {'ensure'=> 'present', 'content'=> 'bar'},
      }
    }
  } end

  it { should contain_file('/tmp/foo').with_content('foo') }
  it { should contain_file('/tmp/bar').with_content('bar') }
end
