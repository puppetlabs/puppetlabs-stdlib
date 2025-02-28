# frozen_string_literal: true

require 'spec_helper'

%w[ensure_resources stdlib::ensure_resources].each do |function|
  describe function do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects between 2 and 3 arguments, got none}) }
    it { is_expected.to run.with_params('type').and_raise_error(ArgumentError, %r{expects between 2 and 3 arguments, got 1}) }

    describe 'given a title hash of multiple resources' do
      before(:each) do
        subject.execute('user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' }, 'alex' => { 'gid' => 'mygroup', 'uid' => '700' } }, 'ensure' => 'present')
      end

      # this lambda is required due to strangeness within rspec-puppet's expectation handling
      it { expect(-> { catalogue }).to contain_user('dan').with_ensure('present') }
      it { expect(-> { catalogue }).to contain_user('alex').with_ensure('present') }
      it { expect(-> { catalogue }).to contain_user('dan').with('gid' => 'mygroup', 'uid' => '600') }
      it { expect(-> { catalogue }).to contain_user('alex').with('gid' => 'mygroup', 'uid' => '700') }
    end

    describe 'given a title hash of a single resource' do
      before(:each) { subject.execute('user', { 'dan' => { 'gid' => 'mygroup', 'uid' => '600' } }, 'ensure' => 'present') }

      # this lambda is required due to strangeness within rspec-puppet's expectation handling
      it { expect(-> { catalogue }).to contain_user('dan').with_ensure('present') }
      it { expect(-> { catalogue }).to contain_user('dan').with('gid' => 'mygroup', 'uid' => '600') }
    end
  end
end
