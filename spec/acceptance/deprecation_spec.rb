#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'
require 'shellwords'

describe 'deprecation function' do

  context 'with --strict=error', if: get_puppet_version =~ /^4/ do
    before :all do
      pp = <<-EOS
      deprecation('key', 'message')
      notify { 'deprecation msg': }
      EOS
      @result = on(default, puppet('apply', '--strict=error', '-e', Shellwords.shellescape(pp)), acceptable_exit_codes: (0...256))
    end

    it "should return an error" do
      expect(@result.exit_code).to eq(1)
    end

    it "should show the error message" do
      expect(@result.stderr).to match(/deprecation. key. message/)
    end
  end

  context 'with --strict=warning', if: get_puppet_version =~ /^4/ do
    before :all do
      pp = <<-EOS
      deprecation('key', 'message')
      notify { 'deprecation msg': }
      EOS
      @result = on(default, puppet('apply', '--strict=warning', '-e', Shellwords.shellescape(pp)), acceptable_exit_codes: (0...256))
    end

    it "should not return an error" do
      expect(@result.exit_code).to eq(0)
    end

    it "should show the error message" do
      expect(@result.stderr).to match(/Warning: message/)
    end
  end

  context 'with --strict=off', if: get_puppet_version =~ /^4/ do
    before :all do
      pp = <<-EOS
      deprecation('key', 'message')
      notify { 'deprecation msg': }
      EOS
      @result = on(default, puppet('apply', '--strict=off', '-e', Shellwords.shellescape(pp)), acceptable_exit_codes: (0...256))
    end

    it "should not return an error" do
      expect(@result.exit_code).to eq(0)
    end

    it "should not show the error message" do
      expect(@result.stderr).not_to match(/Warning: message/)
    end
  end
end
