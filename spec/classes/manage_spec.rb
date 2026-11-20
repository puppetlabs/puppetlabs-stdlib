# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::manage' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  describe 'with resources to create' do
    let :pre_condition do
      <<-PRECOND
        file { '/etc/motd.d' : }
        service { 'sshd' : }

        function epp(*$args) { 'I am an epp template' }
        function inline_epp(*$args) { 'I am an inline epp template' }
        function template(*$args) { 'I am an erb template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/motd.d/hello' => {
              'content' => 'I say Hi',
              'notify' => 'Service[sshd]'
            },
            '/etc/motd' => {
              'epp' => {
                'template' => 'profile/motd.epp'
              }
            },
            '/etc/inline' => {
              'epp' => {
                'inline' => 'Hello <%= $name %>',
                'context' => { 'name' => 'world' }
              }
            },
            '/etc/inline_nocontext' => {
              'epp' => {
                'inline' => 'Hello world'
              }
            },
            '/etc/information' => {
              'erb' => {
                'template' => 'profile/information.erb'
              }
            }
          },
          'concat' => {
            '/tmp/filename' => {
              'ensure' => 'present',
            }
          },
          'concat::fragment' => {
            'rawcontent' => {
              'target' => '/tmp/filename',
              'content' => 'test content',
            },
            'eppcontent' => {
              'target' => '/tmp/filename',
              'epp' => {
                'template' => 'profile/motd.epp'
              },
            },
            'erbcontent' => {
              'target' => '/tmp/filename',
              'erb' => {
                'template' => 'profile/information.erb'
              },
            },
            'eppcontent_inline' => {
              'target' => '/tmp/filename',
              'epp' => {
                'inline' => 'inline fragment content'
              },
            }
          },
          'package' => {
            'example' => {
              'ensure' => 'installed',
              'subscribe' => ['Service[sshd]', 'File[/etc/motd.d]']
            }
          }
        }
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_file('/etc/motd.d/hello').with_content('I say Hi').with_notify('Service[sshd]') }
    it { is_expected.to contain_file('/etc/motd').with_content(%r{I am an epp template}) }
    it { is_expected.to contain_file('/etc/inline').with_content(%r{I am an inline epp template}) }
    it { is_expected.to contain_file('/etc/inline_nocontext').with_content(%r{I am an inline epp template}) }
    it { is_expected.to contain_file('/etc/information').with_content(%r{I am an erb template}) }
    it { is_expected.to contain_concat('/tmp/filename') }
    it { is_expected.to contain_concat__fragment('rawcontent').with_content('test content') }
    it { is_expected.to contain_concat__fragment('eppcontent').with_content(%r{I am an epp template}) }
    it { is_expected.to contain_concat__fragment('erbcontent').with_content(%r{I am an erb template}) }
    it { is_expected.to contain_concat__fragment('eppcontent_inline').with_content(%r{I am an inline epp template}) }
    it { is_expected.to contain_package('example').with_ensure('installed').that_subscribes_to(['Service[sshd]', 'File[/etc/motd.d]']) }
  end

  describe 'with file epp and content' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'epp' => {
                'template' => 'profile/test.epp'
              },
              'content' => 'conflicting content'
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'epp' and 'content'}) }
  end

  describe 'with file erb and content' do
    let :pre_condition do
      <<-PRECOND
        function template(*$args) { 'I am an erb template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'erb' => {
                'template' => 'profile/test.erb'
              },
              'content' => 'conflicting content'
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'erb' and 'content'}) }
  end

  describe 'with file erb and epp' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
        function template(*$args) { 'I am an erb template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'epp' => {
                'template' => 'profile/test.epp'
              },
              'erb' => {
                'template' => 'profile/test.erb'
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'erb' and 'epp'}) }
  end

  describe 'with file epp template and inline' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'epp' => {
                'template' => 'profile/test.epp',
                'inline' => 'inline content'
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set both 'template' and 'inline'}) }
  end

  describe 'with file epp neither template nor inline' do
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'epp' => {
                'context' => {}
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{No template or inline configured}) }
  end

  describe 'with file erb but no template' do
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/test' => {
              'erb' => {}
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{No template configured for erb}) }
  end

  describe 'with concat::fragment epp and content' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'epp' => {
                'template' => 'profile/test.epp'
              },
              'content' => 'conflicting content'
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'epp' and 'content'}) }
  end

  describe 'with concat::fragment erb and content' do
    let :pre_condition do
      <<-PRECOND
        function template(*$args) { 'I am an erb template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'erb' => {
                'template' => 'profile/test.erb'
              },
              'content' => 'conflicting content'
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'erb' and 'content'}) }
  end

  describe 'with concat::fragment erb and epp' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
        function template(*$args) { 'I am an erb template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'epp' => {
                'template' => 'profile/test.epp'
              },
              'erb' => {
                'template' => 'profile/test.erb'
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set 'erb' and 'epp'}) }
  end

  describe 'with concat::fragment epp template and inline' do
    let :pre_condition do
      <<-PRECOND
        function epp(*$args) { 'I am an epp template' }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'epp' => {
                'template' => 'profile/test.epp',
                'inline' => 'inline content'
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{You can not set both 'template' and 'inline'}) }
  end

  describe 'with concat::fragment epp neither template nor inline' do
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'epp' => {
                'context' => {}
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{No template or inline configured}) }
  end

  describe 'with concat::fragment erb but no template' do
    let :params do
      {
        'create_resources' => {
          'concat::fragment' => {
            'test' => {
              'target' => '/tmp/file',
              'erb' => {}
            }
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{No template configured for erb}) }
  end
end
