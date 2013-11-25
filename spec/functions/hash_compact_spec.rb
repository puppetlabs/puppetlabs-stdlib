require 'spec_helper'

describe 'hash_compact' do
  context "given truthy values" do
    it "returns keys with truthy values" do
      subject.should run.with_params(:true_key => true).
        and_return(:true_key => true)
    end
  end

  context "given :undef values" do
    it "removes keys with :undef values" do
      subject.should run.with_params(:undef_key => :undef).
        and_return({})
    end
  end

  context "given a mix of truthy and :undef values" do
    it "returns the keys with truthy values but not the keys with :undef values" do
      subject.should run.with_params(:true_key => true, :undef_key => :undef).
        and_return(:true_key => true)
    end
  end
end
