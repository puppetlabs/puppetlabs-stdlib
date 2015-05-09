#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'url_encode function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'url_encode strings' do
      pp = <<-EOS
      $a = ":/?#[]@!$&'()*+,;= \\\"{}%"
      $o = url_encode($a)
      notice(inline_template('url_encode is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/url_encode is "%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%20%22%7B%7D%25"/)
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
