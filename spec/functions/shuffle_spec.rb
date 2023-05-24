# frozen_string_literal: true

require 'spec_helper'

describe 'shuffle' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  it {
    pending('Current implementation ignores parameters after the first.')
    expect(subject).to run.with_params([], 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i)
  }

  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }
  it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, %r{Requires either array or string to work}) }

  context 'when running with a specific seed' do
    # make tests deterministic
    before(:each) { srand(2) }

    it { is_expected.to run.with_params([]).and_return([]) }
    it { is_expected.to run.with_params(['a']).and_return(['a']) }
    it { is_expected.to run.with_params(['one']).and_return(['one']) }

    if Puppet::PUPPETVERSION[0].to_i < 8
      it { is_expected.to run.with_params(['one', 'two', 'three']).and_return(['two', 'one', 'three']) }
      it { is_expected.to run.with_params(['one', 'two', 'three', 'four']).and_return(['four', 'three', 'two', 'one']) }

      it { is_expected.to run.with_params('').and_return('') }
      it { is_expected.to run.with_params('a').and_return('a') }
      it { is_expected.to run.with_params('abc').and_return('bac') }
      it { is_expected.to run.with_params('abcd').and_return('dcba') }

      context 'with UTF8 and double byte characters' do
        it { is_expected.to run.with_params('ůţƒ8 ŧέχŧ şŧґíńģ').and_return('ģńş ůχţέƒŧí8ґŧŧ ') }
        it { is_expected.to run.with_params('日本語の文字列').and_return('字本日語文列の') }
      end

      context 'when using a class extending String' do
        it { is_expected.to run.with_params(AlsoString.new('asdfghjkl')).and_return('lkhdsfajg') }
      end
    else
      it { is_expected.to run.with_params(['one', 'two', 'three']).and_return(['one', 'three', 'two']) }
      it { is_expected.to run.with_params(['one', 'two', 'three', 'four']).and_return(['one', 'three', 'two', 'four']) }

      it { is_expected.to run.with_params('b').and_return('b') }
      it { is_expected.to run.with_params('abc').and_return('acb') }
      it { is_expected.to run.with_params('abcd').and_return('acbd') }

      context 'with UTF8 and double byte characters' do
        it { is_expected.to run.with_params('ůţƒ8 ŧέχŧ şŧґíńģ').and_return('ŧńş ģχţέƒůí8ґŧŧ ') }
        it { is_expected.to run.with_params('日本語の文字列').and_return('日列語字本文の') }
      end

      context 'when using a class extending String' do
        it { is_expected.to run.with_params(AlsoString.new('asdfghjkl')).and_return('lakfdgjsh') }
      end
    end
  end
end
