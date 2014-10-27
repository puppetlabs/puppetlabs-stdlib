module Puppet::Parser::Functions
  newfunction(:append_file_content, :doc => <<-'ENDHEREDOC') do |args|
    Add content to a file resource.

    This allows to generate concatenated files on the master side,
    without managing multiple file resources.

    The first argument is the file path. You are responsible for
    creating the file resource yourself prior to calling the
    function. This way, you can finely control the file's
    parameters.

    The second argument is the content to be added to the file.

    The third (optional) argument is the order, specifying the
    position in which the content should be added. The default
    order is '10'. If you specified a content in the original
    file resource, this content is kept with order '00'

    Examples:

        file { '/tmp/target':
          content => "Orig content\n",
        }

        append_file_content('/tmp/target', "hello, ")
        append_file_content('/tmp/target', "world\n")
        append_file_content('/tmp/target', "This is a multi
        line statement
        ", '01')
        append_file_content('/tmp/target', template('foobar/example.erb'), '05')

    ENDHEREDOC

    file, content, order = args
    order ||= '10'

    function_validate_absolute_path([file])
    function_validate_string([content])
    function_validate_string([order])
    function_validate_re([order, '^\d{2}$', "order must be a two-digit number, not #{order}"])

    @append_content_data ||= {}

    # Find resource
    if resource = findresource("File[#{file}]")
      @append_content_data[file] ||= [{
        :content => resource[:content],
        :order   => '00',
      }]

      @append_content_data[file] << {
        :content => content,
        :order   => order,
      }

      resource[:content] = @append_content_data[file].sort_by { |c|
        [c[:order], c[:content]]
      }.map { |c| c[:content] }.join
    else
      raise Puppet::Error, "You must create a file resource for #{file} before calling this function"
    end
  end
end
