require 'fileutils'

Puppet::Type.type(:remote_file).provide(:curl) do
  desc "Curl support for retrieving remote files"

  confine :feature => :posix

  include Puppet::Util::POSIX
  include Puppet::Util::Warnings

  require 'etc'
  require 'open-uri'
  require 'digest'

  commands :curlcmd => 'curl'

  def create
    curlcmd '--fail', '--silent', '--show-error', '-o', resource[:path], resource[:source]

    if resource[:checksum] != :no
      unless local_and_remote_checksums_match?
        raise Puppet::Error, 'Checksum of downloaded file is incorrect'
      end
    end

    # Make sure the mode/owner/group is correct
    should_mode = @resource.should(:mode)
    self.mode = should_mode unless self.mode == should_mode
    should_owner = @resource.should(:owner)
    self.owner = should_owner unless self.owner == should_owner
    should_group = @resource.should(:group)
    self.group = should_group unless self.group == should_group

  end

  def destroy
    FileUtils.unlink resource[:path]
  end

  def exists?
    if File.exists?(resource[:path])
      # Only validate the checksums if the user wants this
      if resource[:checksum] == :sha1
        return local_and_remote_checksums_match?
      else
        return true
      end
    else
      return false
    end
  end

  def local_and_remote_checksums_match?
    begin
      local_checksum = Digest::SHA1.file(resource[:path]).hexdigest
    rescue => detail
      raise Puppet::Error, "Failed to calculate checksum of '#{resource[:path]}': #{detail}"
    end

    begin
      remote_checksum = open("#{resource[:source]}.sha1").read
    rescue => detail
      raise Puppet::Error, "Failed to retrieve remote checksum file '#{resource[:source]}.sha1': #{detail}"
    end

    return local_checksum == remote_checksum
  end

  # Return the mode as an octal string, not as an integer.
  def mode
    if File.exists?(resource[:name])
      return (File.stat(resource[:name]).mode & 007777).to_s(8)
    else
      return :absent
    end
  end

  # Set the file mode, converting from a string to an integer.
  def mode=(value)
    begin
      File.chmod(value.to_i(8), resource[:name])
    rescue => detail
      raise Puppet::Error, "Failed to set mode to '#{value}': #{detail}"
    end
  end

  def owner
    if File.exists?(resource[:name])
      uid2name(File.stat(resource[:name]).uid)
    else
      :absent
    end
  end

  def owner=(value)
    begin
      File.chown(name2uid(resource[:owner]), nil, resource[:name])
    rescue => detail
      raise Puppet::Error, "Failed to set owner to '#{value}': #{detail}"
    end
  end

  def group
    if File.exists?(resource[:name])
      gid2name(File.stat(resource[:name]).gid)
    else
      :absent
    end
  end

  def group=(value)
    begin
      File.chown(nil, name2gid(resource[:group]), resource[:name])
    rescue => detail
      raise Puppet::Error, "Failed to set group to '#{value}': #{detail}"
    end
  end

  def uid2name(id)
    return id.to_s if id.is_a?(Symbol) or id.is_a?(String)
    return nil if id > Puppet[:maximum_uid].to_i

    begin
      user = Etc.getpwuid(id)
    rescue TypeError, ArgumentError
      return nil
    end

    if user.uid == ""
      return nil
    else
      return user.name
    end
  end

  # Determine if the user is valid, and if so, return the UID
  def name2uid(value)
    Integer(value) rescue uid(value) || false
  end

  def gid2name(id)
    return id.to_s if id.is_a?(Symbol) or id.is_a?(String)
    return nil if id > Puppet[:maximum_uid].to_i

    begin
      group = Etc.getgrgid(id)
    rescue TypeError, ArgumentError
      return nil
    end

    if group.gid == ""
      return nil
    else
      return group.name
    end
  end

  def name2gid(value)
    Integer(value) rescue gid(value) || false
  end

end
