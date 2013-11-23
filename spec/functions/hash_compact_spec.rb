require 'spec_helper'

describe 'hash_compact' do
  context "given truthy values" do
    it "returns keys with truthy values" do
      subject.should run.with_params(true_key: true).and_return(true_key: true)
    end
  end

  context "given nil values" do
    it "removes keys with nil values" do
      subject.should run.with_params(nil_key: nil).and_return({})
    end
  end

  context "given a mix of truthy and nily values" do
    it "returns the keys with truthy values but not the keys with nily values" do
      subject.should run.with_params(true_key: true, nil_key: nil).and_return(true_key: true)
    end
  end
end
