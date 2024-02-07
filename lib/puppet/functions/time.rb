# frozen_string_literal: true

# @summary DEPRECATED.  Use the native Puppet fuctionality instead of this function. eg `Integer(Timestamp().strftime('%s'))`
Puppet::Functions.create_function(:time) do
  dispatch :call_puppet_function do
    repeated_param 'Any', :args
  end
  def call_puppet_function(*args)
    # Note, `stdlib::time` calls `deprecation`, so we don't also do that here.
    call_function('stdlib::time', *args)
  end
end
