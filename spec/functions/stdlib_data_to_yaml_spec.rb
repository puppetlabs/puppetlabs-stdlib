require 'spec_helper'

describe 'stdlib::data_to_yaml' do

  it { is_expected.to run.with_params(["one", "two", "three"]).and_return("---\n- one\n- two\n- three\n") }

  it { is_expected.to run.with_params({"one" => "1", "two" => "2"}).and_return("---\none: '1'\ntwo: '2'\n") }

end
