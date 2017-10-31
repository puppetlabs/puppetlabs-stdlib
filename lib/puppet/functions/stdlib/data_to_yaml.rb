require 'yaml'

Puppet::Functions.create_function(:'stdlib::data_to_yaml') do
  dispatch :to_yaml do
    param 'Data', :hash_or_array
  end

  def to_yaml(hash_or_array)
    hash_or_array.to_yaml
  end
end
