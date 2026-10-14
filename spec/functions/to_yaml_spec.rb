# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::to_yaml' do
  it { is_expected.not_to be_nil }

  # Basic scalars
  it { is_expected.to run.with_params('').and_return("--- ''\n") }
  it { is_expected.to run.with_params(true).and_return("--- true\n") }
  it { is_expected.to run.with_params(false).and_return("--- false\n") }
  it { is_expected.to run.with_params(42).and_return("--- 42\n") }
  it { is_expected.to run.with_params('one').and_return("--- one\n") }

  # Unicode
  it { is_expected.to run.with_params('‰').and_return("--- \"‰\"\n") }
  it { is_expected.to run.with_params('∇').and_return("--- \"∇\"\n") }

  # Arrays
  it { is_expected.to run.with_params([]).and_return("--- []\n") }
  it { is_expected.to run.with_params(['one']).and_return("---\n- one\n") }
  it { is_expected.to run.with_params(['one', 'two']).and_return("---\n- one\n- two\n") }

  # Hashes
  it { is_expected.to run.with_params({}).and_return("--- {}\n") }
  it { is_expected.to run.with_params('key' => 'value').and_return("---\nkey: value\n") }

  # Nested structures
  it {
    is_expected.to run.with_params(
      'one' => { 'oneA' => 'A', 'oneB' => { 'oneB1' => '1', 'oneB2' => '2' } },
      'two' => ['twoA', 'twoB'],
    ).and_return("---\none:\n  oneA: A\n  oneB:\n    oneB1: '1'\n    oneB2: '2'\ntwo:\n- twoA\n- twoB\n")
  }

  # Options: indentation
  it {
    is_expected.to run.with_params(
      { 'foo' => { 'bar' => true, 'baz' => false } },
      'indentation' => 4,
    ).and_return("---\nfoo:\n    bar: true\n    baz: false\n")
  }

  # Frozen options hash must not raise
  it {
    is_expected.to run.with_params(
      { 'foo' => { 'bar' => true } },
      { 'indentation' => 4, 'sort_keys' => true }.freeze,
    ).and_return("---\nfoo:\n    bar: true\n")
  }

  # sort_keys: default behaviour preserves insertion order
  it {
    is_expected.to run.with_params(
      'z' => 1, 'a' => 2, 'm' => 3,
    ).and_return("---\nz: 1\na: 2\nm: 3\n")
  }

  # sort_keys => true: top-level keys sorted
  it {
    is_expected.to run.with_params(
      { 'z' => 1, 'a' => 2, 'm' => 3 },
      'sort_keys' => true,
    ).and_return("---\na: 2\nm: 3\nz: 1\n")
  }

  # sort_keys => true: nested keys sorted
  it {
    is_expected.to run.with_params(
      { 'parent' => { 'z' => 1, 'a' => 2 } },
      'sort_keys' => true,
    ).and_return("---\nparent:\n  a: 2\n  z: 1\n")
  }

  # sort_keys => true: deeply nested keys sorted
  it {
    is_expected.to run.with_params(
      { 'z_parent' => { 'z_child' => 1, 'a_child' => 2 }, 'a_parent' => { 'x' => 5 } },
      'sort_keys' => true,
    ).and_return("---\na_parent:\n  x: 5\nz_parent:\n  a_child: 2\n  z_child: 1\n")
  }

  # sort_keys => true: array order preserved, hashes inside arrays sorted
  it {
    is_expected.to run.with_params(
      { 'items' => [{ 'z' => 1, 'a' => 2 }, { 'x' => 3, 'b' => 4 }] },
      'sort_keys' => true,
    ).and_return("---\nitems:\n- a: 2\n  z: 1\n- b: 4\n  x: 3\n")
  }

  # sort_keys => true: plain array element order preserved
  it {
    is_expected.to run.with_params(
      { 'items' => [3, 1, 2] },
      'sort_keys' => true,
    ).and_return("---\nitems:\n- 3\n- 1\n- 2\n")
  }

  # sort_keys combined with indentation
  it {
    is_expected.to run.with_params(
      { 'z' => { 'b' => 1, 'a' => 2 }, 'a' => 3 },
      'sort_keys' => true, 'indentation' => 4,
    ).and_return("---\na: 3\nz:\n    a: 2\n    b: 1\n")
  }

  # Sensitive data
  context 'with data containing sensitive' do
    it {
      is_expected.to run.with_params(
        'key' => sensitive('value'),
      ).and_return(sensitive("---\nkey: value\n"))
    }

    it {
      is_expected.to run.with_params(
        { 'z' => sensitive('secret'), 'a' => 'public' },
        'sort_keys' => true,
      ).and_return(sensitive("---\na: public\nz: secret\n"))
    }
  end
end
