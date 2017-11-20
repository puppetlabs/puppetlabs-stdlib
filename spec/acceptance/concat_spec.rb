#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'concat function' do
  describe 'success' do
    pp1 = <<-EOS
      $output = concat(['1','2','3'],['4','5','6'])
      validate_array($output)
      if size($output) != 6 {
        fail("${output} should have 6 elements.")
      }
    EOS
    it 'concats one array to another' do
      apply_manifest(pp1, catch_failures: true)
    end

    pp2 = <<-EOS
      $output = concat(['1','2','3'],'4','5','6',['7','8','9'])
      validate_array($output)
      if size($output) != 9 {
        fail("${output} should have 9 elements.")
      }
    EOS
    it 'concats arrays and primitives to array' do
      apply_manifest(pp2, catch_failures: true)
    end

    pp3 = <<-EOS
      $output = concat(['1','2','3'],['4','5','6'],['7','8','9'])
      validate_array($output)
      if size($output) != 9 {
        fail("${output} should have 9 elements.")
      }
    EOS
    it 'concats multiple arrays to one' do
      apply_manifest(pp3, catch_failures: true)
    end

    pp4 = <<-EOS
      $output = concat([{"a" => "b"}], {"c" => "d", "e" => "f"})
      validate_array($output)
      if size($output) != 2 {
        fail("${output} should have 2 elements.")
      }
      if $output[1] != {"c" => "d", "e" => "f"} {
        fail("${output} does not have the expected hash for the second element.")
      }
    EOS
    it 'concats hash arguments' do
      apply_manifest(pp4, catch_failures: true)
    end
  end
end
