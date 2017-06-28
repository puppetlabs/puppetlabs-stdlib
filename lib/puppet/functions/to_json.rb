#
# BASED ON: https://gist.github.com/aj-jester/e0078c38db9eb7c1ef45
# - converted to puppet 4 function.
#
require 'json'

Puppet::Functions.create_function(:sorted_json) do
  dispatch :sorted_json do
    param 'Hash', :arg
  end

  def sorted_generate(obj)
    case obj
      when Fixnum, Float, TrueClass, FalseClass, NilClass
        return obj.to_json
      when String
        # Convert quoted integers (string) to int
        return (obj.match(/\A[-]?[0-9]+\z/) ? obj.to_i : obj).to_json
      when Array
        arrayRet = []
        obj.each do |a|
          arrayRet.push(sorted_generate(a))
        end
        return "[" << arrayRet.join(',') << "]";
      when Hash
        ret = []
        obj.keys.sort.each do |k|
          ret.push(k.to_json << ":" << sorted_generate(obj[k]))
        end
        return "{" << ret.join(",") << "}";
      else
        raise Exception("Unable to handle object of type <%s>" % obj.class.to_s)
    end
  end # end def

  def sorted_json(h)
    sorted_generate(h)
  end
end
