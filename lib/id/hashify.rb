module Id::Hashify
  extend self

  def enhash(value)
    case value
    when Hash
      value.reduce({}) { |acc, (k, v)| acc.merge(k.to_s => enhash(v)) }
    when Array
      value.map { |v| enhash(v) }
    when Id::Model
      value.to_hash
    else
      value
    end
  end

end
