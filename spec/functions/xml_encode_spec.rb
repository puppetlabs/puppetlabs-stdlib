# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::xml_encode' do
  let(:string) { 'this is "my" complicated <String>' }

  it 'exists' do
    expect(subject).not_to be_nil
  end

  describe 'for XML text' do
    let(:expected_result) { 'this is "my" complicated &lt;String&gt;' }

    context 'with `type` parameter not explicity set' do
      it { is_expected.to run.with_params(string).and_return(expected_result) }
    end

    context 'with `type` parameter set to `text`' do
      it { is_expected.to run.with_params(string, 'text').and_return(expected_result) }
    end
  end

  describe 'for XML attributes' do
    it { is_expected.to run.with_params(string, 'attr').and_return('"this is &quot;my&quot; complicated &lt;String&gt;"') }
  end
end
