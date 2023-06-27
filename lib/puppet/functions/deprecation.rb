# frozen_string_literal: true

# @summary Function to print deprecation warnings, Logs a warning once for a given key.
Puppet::Functions.create_function(:deprecation) do
  # @param key
  #   The uniqueness key.  This function logs once for any given key.
  # @param message
  #   Is the message text including any positional information that is formatted by the user/caller of the function.
  # @param use_strict_setting
  #   When `true`, (the default), the function is affected by the puppet setting 'strict', which can be set to :error
  #   (outputs as an error message), :off (no message / error is displayed) and :warning
  #   (default, outputs a warning).
  dispatch :deprecation do
    param 'String', :key
    param 'String', :message
    optional_param 'Boolean', :use_strict_setting
  end

  def deprecation(key, message, use_strict_setting = true) # rubocop:disable Style/OptionalBooleanParameter
    if defined? Puppet::Pops::PuppetStack.stacktrace
      stacktrace = Puppet::Pops::PuppetStack.stacktrace
      file = stacktrace[0]
      line = stacktrace[1]
      message = "#{message} at #{file}:#{line}"
    end

    # Do nothing if using strict setting and strict is set to `off`
    return if use_strict_setting && Puppet.settings[:strict] == :off

    # Fail hard if using strict setting and strict is set to `error`
    raise("deprecation. #{key}. #{message}") if use_strict_setting && Puppet.settings[:strict] == :error

    # Otherwise raise a soft warning
    # (unless the STDLIB_LOG_DEPRECATIONS has been set to `false`.  This is mainly for use in rspec-puppet testing to suppress noise in logs)
    Puppet.deprecation_warning(message, key) unless ENV['STDLIB_LOG_DEPRECATIONS'] == 'false'
    nil
  end
end
