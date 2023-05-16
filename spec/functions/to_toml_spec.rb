# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::to_toml' do
  context 'fails on invalid params' do
    it { is_expected.not_to be_nil }

    [
      nil,
      '',
      'foobar',
      1,
      true,
      false,
      [],
    ].each do |value|
      it { is_expected.to run.with_params(value).and_raise_error(ArgumentError) }
    end
  end

  context 'returns TOML string on valid params' do
    it { is_expected.to run.with_params({}).and_return('') }
    it { is_expected.to run.with_params(foo: 'bar').and_return("foo = \"bar\"\n") }
    it { is_expected.to run.with_params(foo: { bar: 'baz' }).and_return("[foo]\nbar = \"baz\"\n") }
    it { is_expected.to run.with_params(foo: ['bar', 'baz']).and_return("foo = [\"bar\", \"baz\"]\n") }
    it { is_expected.to run.with_params(foo: [{ bar: {}, baz: {} }]).and_return("[[foo]]\n[foo.bar]\n[foo.baz]\n") }
  end
end
