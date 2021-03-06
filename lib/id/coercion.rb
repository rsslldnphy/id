module Id::Coercion
  extend self

  def register(from, to, &coercion)
    warn "Id - Overwriting existing coercion" if coercions.has_key?([from, to])
    coercions[[from, to]] = coercion
  end

  def coerce(value, type)
    return value.map { |v| coerce(v, type) } if value.is_a? Option
    return (value || []).map { |v| coerce(v, type.first) } if type.is_a? Array
    return value if value.is_a? type
    return type.new(value) if type.include? Id::Model

    coercion = coercions.fetch([value.class, type], false)
    fail Id::CoercionError, [value.class, type] unless coercion
    coercion.call(value)
  end

  private

  def coercions
    @coercions ||= {}
  end

end

class Id::CoercionError < StandardError
  def initialize((from, to))
    super "No available coercion from #{from} to #{to}"
  end
end

Id::Coercion.register String, Integer,     &:to_i
Id::Coercion.register String, Float,       &:to_f
Id::Coercion.register String, Date,        &Date.method(:parse)
Id::Coercion.register String, Time,        &Time.method(:parse)
Id::Coercion.register String, Id::Boolean, &Id::Boolean.method(:parse)
Id::Coercion.register Fixnum, Id::Boolean, &Id::Boolean.method(:parse)
Id::Coercion.register TrueClass, Id::Boolean, &Id::Boolean.method(:parse)
Id::Coercion.register FalseClass, Id::Boolean, &Id::Boolean.method(:parse)
