# frozen_string_literal: true

# @summary
#   Given a username returns the user's entry from the `/etc/passwd` file.
#
# >* Note:*   The `stdlib::getpwnam` function will work only on platforms that support
#   `getpwnam`. Typically that is on POSIX like OSes and not Windows.
#
Puppet::Functions.create_function(:'stdlib::getpwnam') do
  # @param user
  #    The username to fetch password record for.
  #
  # @example Get a password entry for user steve as a hash.
  #   $passwd_entry = stdlib::getpwnam('steve')
  #
  # @example Get the UID of user steve
  #   $uid = stdlib::getpwnam('steve')["uid"]
  #
  # @raise ArgumentError if no password entry can be found for the specified user.
  #
  # @return
  #   [Hash] For example `{"name"=>"root", "passwd"=>"x", "uid"=>0, "gid"=>0, "gecos"=>"root", "dir"=>"/root", "shell"=>"/bin/bash"}`
  dispatch :getpwnam do
    param 'String', :user
    return_type 'Hash'
  end

  def getpwnam(user)
    Etc.getpwnam(user).to_h.first(7).map { |k, v| { k.to_s => v } }.reduce(:merge)
  end
end
