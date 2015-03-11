#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec-puppet'
require 'puppet_spec/compiler'

describe 'append_file_content' do
  include PuppetSpec::Compiler

  context 'when testing signature' do
    let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

    context 'when file resource does not exist yet' do
      it 'should fail' do
        expect {
          scope.function_append_file_content(['/tmp/foo', 'content'])
        }.to raise_error(Puppet::Error, /You must create a file resource for/)
      end
    end

    context 'when file is not an absolute path' do
      it 'should fail' do
        expect {
          scope.function_append_file_content(['foobar', 'content'])
        }.to raise_error(Puppet::Error, /"foobar" is not an absolute path/)
      end
    end

    context 'when content is not a string' do
      it 'should fail' do
        expect {
          scope.function_append_file_content(['/tmp/foo', ['content']])
        }.to raise_error(Puppet::Error, /\["content"\] is not a string/)
      end
    end

    context 'when order is not a number' do
      it 'should fail' do
        expect {
          scope.function_append_file_content(['/tmp/foo', 'content', '10e'])
        }.to raise_error(Puppet::Error, /order must be a two-digit number/)
      end
    end
  end

  context 'when testing functionality' do
    before :all do
      Puppet::Parser::Functions.autoloader.loadall
      Puppet::Parser::Functions.function(:append_file_content)
    end

    let :node     do Puppet::Node.new('localhost') end
    let :compiler do Puppet::Parser::Compiler.new(node) end
    let :scope    do Puppet::Parser::Scope.new(compiler) end


    context 'when adding content without initial content' do
      let :catalog do
        compile_to_catalog(<<-EOS
        file { "/tmp/foo": }
        append_file_content('/tmp/foo', 'hello')
                           EOS
                          )
      end

      it 'should contain the new content' do
        expect(catalog.resource(:file, '/tmp/foo')[:content]).to eq('hello')
      end
    end

    context 'when adding content with initial content' do
      let :catalog do
        compile_to_catalog(<<-EOS
        file { "/tmp/foo":
          content => "Hello, ",
        }
        append_file_content('/tmp/foo', 'World!')
                           EOS
                          )
      end

      it 'should add the new content' do
        expect(catalog.resource(:file, '/tmp/foo')[:content]).to eq('Hello, World!')
      end
    end

    context 'when adding content with order' do
      let :catalog do
        compile_to_catalog(<<-EOS
        file { "/tmp/foo":
          content => "Hello, ",
        }
        append_file_content('/tmp/foo', "The end is near")
        append_file_content('/tmp/foo', 'World! ', '05')
                           EOS
                          )
      end

      it 'should position content properly' do
        expect(catalog.resource(:file, '/tmp/foo')[:content]).to eq('Hello, World! The end is near')
      end
    end

    context 'when adding content with same order' do
      let :catalog do
        compile_to_catalog(<<-EOS
        file { "/tmp/foo":
          content => "Hello, ",
        }
        append_file_content('/tmp/foo', 'The end is near', '50')
        append_file_content('/tmp/foo', 'World! ', '05')
        append_file_content('/tmp/foo', 'Here or there? ', '50')
                           EOS
                          )
      end

      it 'should position content alphabetically' do
        expect(catalog.resource(:file, '/tmp/foo')[:content]).to eq('Hello, World! Here or there? The end is near')
      end
    end

    context 'when calling the function from different scopes' do
      let :catalog do
        compile_to_catalog(<<-EOS
        class world {
          append_file_content('/tmp/foo', 'World! ', '05')
        }

        file { "/tmp/foo":
          content => "Hello, ",
        }
        append_file_content('/tmp/foo', 'The end is near', '50')
        append_file_content('/tmp/foo', 'Here or there? ', '50')
        include ::world
                           EOS
                          )
      end

      it 'should position content alphabetically' do
        expect(catalog.resource(:file, '/tmp/foo')[:content]).to eq('Hello, World! Here or there? The end is near')
      end
    end
  end
end
