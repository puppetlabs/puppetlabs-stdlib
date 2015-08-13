require 'spec_helper'

describe 'dos2unix' do

  context 'Converting from dos to unix format' do
    sample_text    = "Hello\r\nWorld\r\n"
    desired_output = "Hello\nWorld\n"

    it 'should output unix format' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end

  context 'Converting from unix to unix format' do
    sample_text    = "Hello\nWorld\n"
    desired_output = "Hello\nWorld\n"

    it 'should output unix format' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end
end
