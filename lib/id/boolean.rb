module Id::Boolean
  extend self

  def parse(value)
    case value
    when String     then ['yes', 'true', '1'].include?(value.to_s.downcase)
    when Symbol     then ['yes', 'true', '1'].include?(value.to_s.downcase)
    when Fixnum     then value != 0
    when TrueClass  then true
    else false
    end
  end

end
