Puppet::Type.type(:file_line).provide(:ruby) do

  def exists?
    File.read(resource[:path]).split($/).index(resource[:line].chomp)
  end

  def create
    File.open(resource[:path], 'a') do |fh|
      fh.puts resource[:line]
    end
  end

end
