Puppet::Type.type(:file_line).provide(:ruby) do
  def exists?
    found = false
    lines_count = 0
    lines.each do |line|
      found = line.chomp == resource[:line]
      if found
        lines_count += 1
      end
    end
    if resource[:match] == nil
      found = lines_count > 0
    else
      match_count = count_matches(new_match_regex)
      if resource[:append_on_no_match].to_s == 'false'
        found = true
      elsif resource[:replace].to_s == 'true'
        found = lines_count > 0 && lines_count == match_count
      else
        found = match_count > 0
      end
    end
    found
  end

  def create
    unless resource[:replace].to_s != 'true' && count_matches(new_match_regex) > 0
      if resource[:match]
        handle_create_with_match
      elsif resource[:after]
        handle_create_with_after
      else
        handle_append_line
      end
    end
  end

  def destroy
    if resource[:match_for_absence].to_s == 'true' && resource[:match]
      handle_destroy_with_match
    else
      handle_destroy_line
    end
  end

  private

  def lines
    # If this type is ever used with very large files, we should
    #  write this in a different way, using a temp
    #  file; for now assuming that this type is only used on
    #  small-ish config files that can fit into memory without
    #  too much trouble.
    begin
      @lines ||= File.readlines(resource[:path], :encoding => resource[:encoding])
    rescue TypeError => e
      # Ruby 1.8 doesn't support open_args
      @lines ||= File.readlines(resource[:path])
    end
  end

  def new_after_regex
    resource[:after] ? Regexp.new(resource[:after]) : nil
  end

  def new_match_regex
    resource[:match] ? Regexp.new(resource[:match]) : nil
  end

  def count_matches(regex)
    lines.select{ |line| line.match(regex) }.size
  end

  def handle_create_with_match()
    after_regex = new_after_regex
    match_regex = new_match_regex
    match_count = count_matches(new_match_regex)

    if match_count > 1 && resource[:multiple].to_s != 'true'
     raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    File.open(resource[:path], 'w') do |fh|
      lines.each do |line|
        fh.puts(match_regex.match(line) ? resource[:line] : line)
        if match_count == 0 && after_regex
          if after_regex.match(line)
            fh.puts(resource[:line])
            match_count += 1 # Increment match_count to indicate that the new line has been inserted.
          end
        end
      end

      if (match_count == 0)
        fh.puts(resource[:line])
      end
    end
  end

  def handle_create_with_after
    after_regex = new_after_regex
    after_count = count_matches(after_regex)

    if after_count > 1 && resource[:multiple].to_s != 'true'
      raise Puppet::Error, "#{after_count} lines match pattern '#{resource[:after]}' in file '#{resource[:path]}'. One or no line must match the pattern."
    end

    File.open(resource[:path],'w') do |fh|
      lines.each do |line|
        fh.puts(line)
        if after_regex.match(line)
          fh.puts(resource[:line])
        end
      end

      if (after_count == 0)
        fh.puts(resource[:line])
      end
    end
  end

  def handle_destroy_with_match
    match_regex = new_match_regex
    match_count = count_matches(match_regex)
    if match_count > 1 && resource[:multiple].to_s != 'true'
     raise Puppet::Error, "More than one line in file '#{resource[:path]}' matches pattern '#{resource[:match]}'"
    end

    local_lines = lines
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{ |line| match_regex.match(line) }.join(''))
    end
  end

  def handle_destroy_line
    local_lines = lines
    File.open(resource[:path],'w') do |fh|
      fh.write(local_lines.reject{ |line| line.chomp == resource[:line] }.join(''))
    end
  end

  def handle_append_line
    File.open(resource[:path],'w') do |fh|
      lines.each do |line|
        fh.puts(line)
      end
      fh.puts(resource[:line])
    end
  end
end
