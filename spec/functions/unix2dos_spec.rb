require 'spec_helper'

describe 'unix2dos' do

  context 'Converting from unix to dos format' do
    sample_text    = "Hello\nWorld\n"
    desired_output = "Hello\r\nWorld\r\n"

    it 'should output dos format' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end

  context 'Converting from dos to dos format' do
    sample_text    = "Hello\r\nWorld\r\n"
    desired_output = "Hello\r\nWorld\r\n"

    it 'should output dos format' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end
end
