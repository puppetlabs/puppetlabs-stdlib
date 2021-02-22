# frozen_string_literal: true

require 'spec_helper'

# Test cases are a combination of the test cases used in MediaWiki[1] and a
# Reference found on line[2].  Some of the test cases in the later list have
# been dropped as the regex used in the HTML5 specification[3] (and in this type)
# allows for wilful violation of the RFC's
#
# [1]https://github.com/wikimedia/mediawiki/blob/master/tests/phpunit/integration \
#   /includes/SanitizerValidateEmailTest.php
# [2]https://gist.github.com/cjaoude/fd9910626629b53c4d25
# [3]https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address

describe 'Stdlib::Email' do
  describe 'valid handling' do
    ['email@example.com',
     'EMAIL@example.com',
     'email@EXAMPLE.com',
     'email@192.0.2.1',
     '_______@example.com',
     'firstname.lastname@example.com',
     'firstname+lastname@example.com',
     'firstname-lastname@example.com',
     '1234567890@example.com',
     'email@subdomain.example.com',
     'email@example-one.com',
     'email@example.name',
     'email@example.museum',
     'email@example.co.jp',
     'email@example',
     'user@example.1234',
     'user@a'].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
  describe 'invalid handling' do
    ['plainaddress',
     '#@%^%#$@#$@#.com',
     '@example.com',
     ' email@example.com',
     'email@example.com ',
     "email@example.com\t",
     'user email@example.com',
     'useremail@example com',
     'user,email@example.com',
     'useremail@example,com',
     'useremail@.',
     'useremail@.example.org',
     'useremail@a......',
     'useràexample.com',
     'Joe Smith <email@example.com>',
     'email.example.com',
     'email@example@example.com',
     'あいうえお@example.com',
     'email@example.com (Joe Smith)',
     'email@-example.com',
     'email@example..com',
     'random stuff multiline
     valid@email.com
     more random stuff $^*!',
     '”(),:;<>[\]@example.com',
     'just”not”right@example.com',
     'this\ is"really"not\allowed@example.com'].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
