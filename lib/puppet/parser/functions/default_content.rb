Puppet::Parser::Functions.newfunction(:default_content,
                                      :type => :rvalue,
                                      :doc => <<-'ENDOFDOC'
Takes an optional content and an optional template name to calculate the actual
contents of a file. The following two statements are equivalent:

    $real_content = default_content($content, $template_name)

    if $content {
      $real_content = $content
    } elsif $template_name {
      $real_content = template($template_name)
    } else {
      $real_content = undef
    }

This small function abbreviates the default initialisation boilerplate of
modules.
ENDOFDOC
) do |args|
    content = args[0]
    template_name = args[1]

    Puppet::Parser::Functions.autoloader.loadall

    return content if content
    return function_template(template_name) if template_name

    return nil
  end
end

