Puppet::Type.type(:file_line).provide(:ruby) do

  def exists?
    lines.find do |line|
      line.chomp == resource[:line].chomp
    end
  end

  def create
    lbr = ends_with_linebreak? ? "\n" : ''
    File.open(resource[:path], 'a') do |fh|
       fh.puts "#{lbr}#{resource[:line]}"
    end
  end

  def destroy
    local_lines = lines
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{|l| l.chomp == resource[:line] }.join(''))
    end
  end

  private
  def lines
    @lines ||= File.readlines(resource[:path])
  end

  def ends_with_linebreak?
    (File.size(resource[:path]) > 0) && File.read(resource[:path],1,File.size(resource[:path])-1) != "\n"
  end

end
