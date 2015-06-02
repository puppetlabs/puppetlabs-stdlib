require 'fileutils'
require 'tempfile'

require 'puppet/util/diff'

Puppet::Type.type(:file_line).provide(:ruby) do
  include Puppet::Util::Diff
  
  def exists?
    lines.find do |line|
      line.chomp == resource[:line].chomp
    end
  end

  def create
    create_temporary_file
    if resource[:match]
      handle_create_with_match
    elsif resource[:after]
      handle_create_with_after
    else
      append_line
    end
    sync
  end

  def destroy
    local_lines = lines
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{|l| l.chomp == resource[:line] }.join(''))
    end
  end

  private
  def lines
    # If this type is ever used with very large files, we should
    #  write this in a different way, using a temp
    #  file; for now assuming that this type is only used on
    #  small-ish config files that can fit into memory without
    #  too much trouble.
    @lines ||= File.readlines(resource[:path])
  end

  def handle_create_with_match()
    regex        = resource[:match]  ? Regexp.new(resource[:match]) : nil
    regex_after  = resource[:after]  ? Regexp.new(resource[:after]) : nil
    regex_unless = resource[:unless] ? Regexp.new(resource[:unless]) : nil
    match_count  = count_matches(regex)

    if match_count > 1 && resource[:multiple].to_s != 'true'
     raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |l|
        if regex.match(l)
            if regex_unless
                unless regex_unless.match(l)
                    write_to_temporary(l.sub(regex, resource[:line]))
                else
                    write_to_temporary(l)
                end
            else
                write_to_temporary(l.sub(regex, resource[:line]))
            end
        else
            write_to_temporary(l)
        end
        if (match_count == 0 and regex_after)
          if regex_after.match(l)
            write_to_temporary(resource[:line])
            match_count += 1 #Increment match_count to indicate that the new line has been inserted.
          end
        end
      end

      if (match_count == 0)
        if resource[:no_append].to_s != 'true'
          write_to_temporary(resource[:line])
        end
      end
    end
  end

  def handle_create_with_after
    regex = Regexp.new(resource[:after])
    count = count_matches(regex)
    case count
    when 1 # find the line to put our line after
      File.open(resource[:path], 'w') do |fh|
        lines.each do |l|
          write_to_temporary(l)
          if regex.match(l) then
            write_to_temporary(resource[:line])
          end
        end
      end
    when 0 # append the line to the end of the file
      append_line
    else
      raise Puppet::Error, "#{count} lines match pattern '#{resource[:after]}' in file '#{resource[:path]}'.  One or no line must match the pattern."
    end
  end

  def count_matches(regex)
    lines.select{|l| l.match(regex)}.size
  end

  ##
  # append the line to the file.
  #
  # @api private
  def append_line
    File.open(resource[:path], 'w') do |fh|
      lines.each do |l|
        write_to_temporary(l)
      end
      write_to_temporary resource[:line]
    end
  end

  def create_temporary_file
    @temfile = nil
    begin
      @tempfile = Tempfile.new("puppet-file")
    rescue SystemCallError => e
      raise Puppet::ParseError, "can not create temporary file: #{e.message}"
    end
    #return @tempfile.open
  end

  def sync
    @tempfile.close(false)
    if Puppet[:show_diff] and resource.show_diff?
        show_diff
    end
    begin
      FileUtils.cp(@tempfile.path, resource[:path])
    rescue SystemCallError => e
      raise Puppet::ParseError, "can not copy #{@tempfile.path} to #{resource[:path]}: #{e.message}"
    end
    @tempfile.unlink
  end

  def show_diff
    send @resource[:loglevel], "\n" + diff(resource[:path], @tempfile.path)
  end

  def write_to_temporary(line)
    begin
      @tempfile.puts(line)
    rescue SystemCallError => e
      raise Puppet::ParseError, "can not write #{line} into #{@tempfile.path}: #{e.message}"
    end
  end
end
