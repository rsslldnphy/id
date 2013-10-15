module Id::Coercion
  extend self

  def register(from, to, &coercion)
    warn "Id - Overwriting existing coercion" if coercions.has_key?([from, to])
    coercions[[from, to]] = coercion
  end

  def coerce(value, type)
    return value if value.is_a? type
    return type.new(value) if type.is_a? Id::Model

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

Id::Coercion.register String, Integer, &:to_i
Id::Coercion.register String, Float,   &:to_f
