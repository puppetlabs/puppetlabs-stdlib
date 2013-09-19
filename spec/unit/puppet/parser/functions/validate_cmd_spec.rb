require 'spec_helper'

describe Puppet::Parser::Functions.function(:validate_cmd) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  subject do
    function_name = Puppet::Parser::Functions.function(:validate_cmd)
    scope.method(function_name)
  end

  describe "with an explicit failure message" do
    it "prints the failure message on error" do
      expect {
        subject.call ['', '/bin/false', 'failure message!']
      }.to raise_error Puppet::ParseError, /failure message!/
    end
  end

  describe "on validation failure" do
    it "includes the command error output" do
      expect {
        subject.call ['', '/bin/touch /cant/touch/this']
      }.to raise_error Puppet::ParseError, /cannot touch/
    end

    it "includes the command return value" do
      expect {
        subject.call ['', '/cant/run/this']
      }.to raise_error Puppet::ParseError, /returned 1\b/
    end
  end

  describe "when performing actual validation" do
    it "can positively validate file content" do
      expect { subject.call ["non-empty", "/usr/bin/test -s"] }.to_not raise_error
    end

    it "can negatively validate file content" do
      expect {
        subject.call ["", "/usr/bin/test -s"]
      }.to raise_error Puppet::ParseError, /failed to validate.*test -s/
    end
  end
end
