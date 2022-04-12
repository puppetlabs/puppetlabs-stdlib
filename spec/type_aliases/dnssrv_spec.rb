# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Dnssrv' do
  describe 'valid handling' do
    [
      '_kerberos.example.com',
      '_kerberos-master._tcp.example.com',
      '_ldap._tcp.dev._locations.example.com',
      '_ldap._tcp.example.com',
      'dev._locations.example.com',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid path handling' do
    context 'garbage inputs' do
      [
        'example',
        'example.com',
        'www.example.com',
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        "\nexample",
        "\nexample\n",
        "example\n",
        '2001:DB8::1',
        'www www.example.com',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
