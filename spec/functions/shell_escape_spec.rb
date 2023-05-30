# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::shell_escape' do
  it { is_expected.not_to be_nil }

  describe 'signature validation' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::shell_escape' expects 1 argument, got none}) }
    it { is_expected.to run.with_params('foo', 'bar').and_raise_error(ArgumentError, %r{'stdlib::shell_escape' expects 1 argument, got 2}) }
  end

  describe 'stringification' do
    it { is_expected.to run.with_params(10).and_return('10') }
    it { is_expected.to run.with_params(false).and_return('false') }
  end

  describe 'escaping' do
    it { is_expected.to run.with_params('foo').and_return('foo') }
    it { is_expected.to run.with_params('foo bar').and_return('foo\ bar') }

    it {
      expect(subject).to run.with_params('~`!@#$%^&*()_-=[]\{}|;\':",./<>?')
                            .and_return('\~\`\!@\#\$\%\^\&\*\(\)_-\=\[\]\\\\\{\}\|\;\\\':\",./\<\>\?')
    }
  end

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('スペー スを含むテ  キスト').and_return('\\ス\\ペ\\ー\\ \\ス\\を\\含\\む\\テ\\ \\ \\キ\\ス\\ト') }
    it { is_expected.to run.with_params('μťƒ 8  ŧĕχť').and_return('\\μ\\ť\\ƒ\\ 8\\ \\ \\ŧ\\ĕ\\χ\\ť') }
  end
end
