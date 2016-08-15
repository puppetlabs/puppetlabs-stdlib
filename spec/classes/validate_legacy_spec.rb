require 'spec_helper'

if Puppet.version.to_f >= 4.0
  # validate_legacy requires a proper scope to run, so we have to trigger a true compilation here,
  # instead of being able to leverage the function test group.
  describe 'test::validate_legacy', type: :class do

    describe 'validate_legacy passes assertion of type but not previous validation' do
      let(:params) {{ type: "Optional[Integer]", prev_validation: "validate_re", value: 5, previous_arg1: ["^\\d+$", ""] }}
      it "should pass, warning about the newly accepted value" do
        Puppet.expects(:notice).with(includes('Accepting previously invalid value for target type \'Optional[Integer]\''))
        Puppet.expects(:notice).with(includes('Compiled catalog for'))
        is_expected.to compile
      end
    end

    describe 'validate_legacy passes assertion of type and previous validation' do
      let(:params) {{ type: "Optional[String]", prev_validation: "validate_re", value: "5", previous_arg1: ["."] }}
      it "should pass, without notice" do
        Puppet.expects(:warning).never
        is_expected.to compile
      end
    end

    describe 'validate_legacy fails assertion of type and passes previous validation' do
      let(:params) {{ type: "Optional[Integer]", prev_validation: "validate_re", value: "5", previous_arg1: ["."] }}
      it "should pass, with a deprecation warning" do
        Puppet.expects(:warning).with(includes('expected'))
        is_expected.to compile
      end
    end

    describe 'validate_legacy fails assertion and fails previous validation' do
      let(:params) {{ type: "Optional[Integer]", prev_validation: "validate_re", value: "5", previous_arg1: ["thisisnotright"] }}
      it "should fail" do
        is_expected.to compile.and_raise_error(/Error while evaluating a Function Call, .* expected an \w* value, got \w*/)
      end
    end

    describe 'validate_legacy can handle undef' do
      let(:params) {{ type: "Optional[Integer]", prev_validation: "validate_re", value: :undef, previous_arg1: ["thisisnotright"] }}
      it "should pass" do
        is_expected.to compile
      end
    end

    describe 'validate_legacy works with multi-argument validate_ functions' do
      let(:params) {{ type: "Integer", prev_validation: "validate_integer", value: 10, previous_arg1: 100, previous_arg2: 0 }}
      it { is_expected.to compile }
    end
  end
end
