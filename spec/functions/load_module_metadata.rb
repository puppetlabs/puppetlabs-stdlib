require 'spec_helper'

describe 'load_module_metadata' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params("one", "two").and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

  it "should json parse the file" do
     allow(scope).to receive(:function_get_module_path).with(['science']).and_return('/path/to/module/')
     allow(File).to receive(:exists?).with(/metadata.json/).and_return(true)
     allow(File).to receive(:read).with(/metadata.json/).and_return('{"name": "spencer-science"}')

     result = subject.call(['science'])
     expect(result['name']).to eq('spencer-science')
  end
end
