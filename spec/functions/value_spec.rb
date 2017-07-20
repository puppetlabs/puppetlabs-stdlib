require 'spec_helper'

describe 'value' do
  let(:facts) do
    {
      'networking' => {
          'interfaces' => {
              'docker0' =>
              {
                  'ip' => '1.2.3.4'
              },
          },
      },
    }
  end

  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(ArgumentError) }

  it 'should properly delegate' do
    is_expected.to run.with_params(facts, 'networking.interfaces.docker0.ip').and_return('1.2.3.4')
  end

end
