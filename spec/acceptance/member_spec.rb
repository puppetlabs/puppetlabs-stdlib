#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'member function' do
  shared_examples 'item found' do
    it 'outputs correctly' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'success' do
    pp1 = <<-EOS
      $a = ['aaa','bbb','ccc']
      $b = 'ccc'
      $c = true
      $o = member($a,$b)
      if $o == $c {
        notify { 'output correct': }
      }
    EOS
    it 'members arrays' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    describe 'members array of integers' do
      it_behaves_like 'item found' do
        let(:pp) do # rubocop:disable RSpec/LetBeforeExamples : 'let' required to be inside example for it to work
          <<-EOS
            if member( [1,2,3,4], 4 ){
              notify { 'output correct': }
            }
          EOS
        end
      end
    end
    describe 'members of mixed array' do
      it_behaves_like 'item found' do
        let(:pp) do # rubocop:disable RSpec/LetBeforeExamples : 'let' required to be inside example for it to work
          <<-EOS
            if member( ['a','4',3], 'a' ){
              notify { 'output correct': }
            }
          EOS
        end
      end
    end
    it 'members arrays without members'
  end

  describe 'failure' do
    it 'handles improper argument counts'
  end
end
