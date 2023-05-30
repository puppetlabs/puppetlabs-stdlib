# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::to_json_pretty' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params([]).and_return("[\n\n]\n") }
  it { is_expected.to run.with_params(['one']).and_return("[\n  \"one\"\n]\n") }
  it { is_expected.to run.with_params(['one', 'two']).and_return("[\n  \"one\",\n  \"two\"\n]\n") }
  it { is_expected.to run.with_params({}).and_return("{\n}\n") }
  it { is_expected.to run.with_params('key' => 'value').and_return("{\n  \"key\": \"value\"\n}\n") }

  it {
    expect(subject).to run.with_params('one' => { 'oneA' => 'A', 'oneB' => { 'oneB1' => '1', 'oneB2' => '2' } }, 'two' => ['twoA', 'twoB'])
                          .and_return("{\n  \"one\": {\n    \"oneA\": \"A\",\n    \"oneB\": {\n      \"oneB1\": \"1\",\n      \"oneB2\": \"2\"\n    }\n  },\n  \"two\": [\n    \"twoA\",\n    \"twoB\"\n  ]\n}\n") # rubocop:disable Layout/LineLength : Unable to reduce line to required length
  }

  it { is_expected.to run.with_params({ 'one' => '1', 'two' => nil }, true).and_return("{\n  \"one\": \"1\"\n}\n") }
  it { is_expected.to run.with_params(['one', 'two', nil, 'three'], true).and_return("[\n  \"one\",\n  \"two\",\n  \"three\"\n]\n") }
  it { is_expected.to run.with_params(['one', 'two', nil, 'three'], true, 'indent' => '@@@@').and_return("[\n@@@@\"one\",\n@@@@\"two\",\n@@@@\"three\"\n]\n") }

  it {
    pending('Current implementation only elides nil values for arrays of depth=1')
    expect(subject).to run.with_params([[nil], 'two', nil, 'three'], true).and_return("[\n  [\n\n  ],\n  \"two\",\n  \"three\"\n]\n")
  }

  it {
    pending('Current implementation only elides nil values for hashes of depth=1')
    expect(subject).to run.with_params({ 'omg' => { 'lol' => nil }, 'what' => nil }, true).and_return("{\n}\n")
  }
end
