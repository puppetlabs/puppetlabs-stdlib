# Recursive function that builds json from a hash
def hash_to_json (hash, json, depth)
  # Base case: If the hash has been completely parsed, return the json string
  return json if !hash.is_a?(Hash)

  # Since puppet generates the hash with random KV pairs ordering every time,
  # we want to maintain the same json output to avoid triggering refresh events
  # so we have to sort the hash in order
  hash = hash.sort
  json = "{\n"
  hash.each_with_index do |(key, value), index|
    # Convert the key to a quoted string
    key = key.inspect
    # Check for value type and convert to quoted string if it is a string
    value = value.inspect if value.is_a?(String)
    # If the value pair is an array build a new json string recursively
    # and concatenate it with brackets as a string
    if value.is_a?(Array)
      json2 = ""
      value.each_with_index do |val, i|
        json2 += val.inspect if val.is_a?(String)
        json2 += hash_to_json(val, "", depth + 1) if val.is_a?(Hash)
        json2 += "," unless i == value.length - 1
      end
      value = "[" + json2 + "]"
    end
    # Recurse hash_to_json with one more depth level to build any hashes
    # that exists as a value on the KV pair
    value = hash_to_json(value, json, depth + 1) if value.is_a?(Hash)
    # Depth is used here to correctly indent the KV output line
    depth.times do
      json += "\t"
    end
    # Concatenate the key and value pair in the correct json format
    json += "#{key}: #{value}"
    # Add trailing comma unless the it is the last KV pair
    json += "," unless (index + 1) == hash.length
    json += "\n"
  end
  # Depth is used here to correctly indent the closing bracket
  (depth-1).times do
    json += "\t"
  end
  json += "}"
end

module Puppet::Parser::Functions
  newfunction(:hash2json, :type => :rvalue, :doc => <<-EOS
Converts a hash to a sorted json string. This function supports nested hashes.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "hash2json(): Wrong number of arguments given (#{args.size} for 1)") unless args.size == 1
    raise(Puppet::ParseError, "hash2json(): First argument must be a Hash") unless args[0].is_a?(Hash)

    hash = args[0]
    json = hash_to_json(hash, "", 1)
    return json
  end
end
