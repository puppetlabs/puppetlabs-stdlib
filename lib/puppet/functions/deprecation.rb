# Function to print deprecation warnings, Logs a warning once for a given key. The uniqueness key - can appear once. The msg is the message text including any positional information that is formatted by the user/caller of the method  It is affected by the puppet setting 'strict', which can be set to :error (outputs as an error message), :off (no message / error is displayed) and :warning (default, outputs a warning)  *Type*: String, String.

Puppet::Functions.create_function(:deprecation) do
  dispatch :deprecation do
    param 'String', :key
    param 'String', :message
  end

  def deprecation(key, message)
    # depending on configuration setting of strict
    caller_infos = caller.first.split(":")
    case Puppet.settings[:strict]
    when :off
      # do nothing
    when :error
      err_message = "#{message} : #{caller_infos[0]} : #{caller_infos[1]}"
      fail("deprecation. #{key}. #{err_message}")
    else
      err_message = "#{message} : #{caller_infos[0]} : #{caller_infos[1]}"
      Puppet.deprecation_warning(err_message, key)
    end
  end
end
