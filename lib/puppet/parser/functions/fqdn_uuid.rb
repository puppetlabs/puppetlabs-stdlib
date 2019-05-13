require 'digest/sha1'
#
# fqdn_uuid.rb
#
module Puppet::Parser::Functions
  newfunction(:fqdn_uuid, :type => :rvalue, :doc => <<-DOC) do |args|
    @summary
      Returns a [RFC 4122](https://tools.ietf.org/html/rfc4122) valid version 5 UUID based
      on an FQDN string under the DNS namespace

    @return
      Returns a [RFC 4122](https://tools.ietf.org/html/rfc4122) valid version 5 UUID

    @example Example Usage:
      fqdn_uuid('puppetlabs.com') # Returns '9c70320f-6815-5fc5-ab0f-debe68bf764c'
      fqdn_uuid('google.com') # Returns '64ee70a4-8cc1-5d25-abf2-dea6c79a09c8'
    DOC

    raise(ArgumentError, 'fqdn_uuid: No arguments given') if args.empty?
    raise(ArgumentError, "fqdn_uuid: Too many arguments given (#{args.length})") unless args.length == 1
    fqdn = args[0]

    # Code lovingly taken from
    # https://github.com/puppetlabs/marionette-collective/blob/master/lib/mcollective/ssl.rb

    # This is the UUID version 5 type DNS name space which is as follows:
    #
    #  6ba7b810-9dad-11d1-80b4-00c04fd430c8
    #
    uuid_name_space_dns = [0x6b,
                           0xa7,
                           0xb8,
                           0x10,
                           0x9d,
                           0xad,
                           0x11,
                           0xd1,
                           0x80,
                           0xb4,
                           0x00,
                           0xc0,
                           0x4f,
                           0xd4,
                           0x30,
                           0xc8].map { |b| b.chr }.join

    sha1 = Digest::SHA1.new
    sha1.update(uuid_name_space_dns)
    sha1.update(fqdn)

    # first 16 bytes..
    bytes = sha1.digest[0, 16].bytes.to_a

    # version 5 adjustments
    bytes[6] &= 0x0f
    bytes[6] |= 0x50

    # variant is DCE 1.1
    bytes[8] &= 0x3f
    bytes[8] |= 0x80

    bytes = [4, 2, 2, 2, 6].map do |i|
      bytes.slice!(0, i).pack('C*').unpack('H*')
    end

    bytes.join('-')
  end
end
