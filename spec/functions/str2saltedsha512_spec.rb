# frozen_string_literal: true

require 'spec_helper'

describe 'str2saltedsha512' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('password', 2).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires a String argument}) }

  context 'when running with a specific seed' do
    # make tests deterministic
    before(:each) { srand(2) }

    if Puppet::PUPPETVERSION[0].to_i < 8
      it {
        expect(subject).to run.with_params('')
                              .and_return('0f8a612f4eeed08e47b3875d00f33c5688f7926298f2d9b5fe19d1323f910bc78b6f7b5892596d2fabaa65e7a8d99b3768c102610cf0432c4827eee01f09451e3fae4f7a')
      }

      it {
        expect(subject).to run.with_params('password')
                              .and_return('0f8a612f43134376566c5707718d600effcfb17581fc9d3fa64d7f447dfda317c174ffdb498d2c5bd5c2075dab41c9d7ada5afbdc6b55354980eb5ba61802371e6b64956')
      }

      it {
        expect(subject).to run.with_params('verylongpassword')
                              .and_return('0f8a612f7a448537540e062daa8621f9bae326ca8ccb899e1bdb10e7c218cebfceae2530b856662565fdc4d81e986fc50cfbbc46d50436610ed9429ff5e43f2c45b5d039')
      }
    else
      it {
        expect(subject).to run.with_params('')
                              .and_return('a85c9d6f8c1eb1a625fd59e3cbca7dc7ab04ff1758d19ab99f098446e14a0a2a42e11afd1f4d6f17adfe2c772a3e6a821ee66a2564711431e14da96a3bff44593cf158ab')
      }

      it {
        expect(subject).to run.with_params('password')
                              .and_return('a85c9d6ff4e4dd6655ec2922ee9752550f2df4dc370e9739dd94899f62be6a42cc31fbfce3d62be35e0e8482696c931f63fb9286cf7b13d283660720c55f2a6304d06958')
      }

      it {
        expect(subject).to run.with_params('verylongpassword')
                              .and_return('a85c9d6fb810d0b8311c9a065c026e3179ae91fee3dbaf556f297e2fda2a8e3d8dd363977f9ef5c9b5da0cd518a5151a4e537928533291d68c9539d4d4b83da53b22a869')
      }
    end
  end
end
