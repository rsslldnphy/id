module Id::Field

  def field(name, options = {})
    send :define_method, name do
      memoized = instance_variable_get "@#{name}"
      return memoized unless memoized.nil?

      key      = options.fetch(:key, name.to_s)
      type     = options.fetch(:type, Object)
      optional = options.fetch(:optional, false)
      default  = options.fetch(:default, nil)
      default  = default.call if default.is_a? Proc

      value = data.fetch(key, default)
      fail Id::MissingAttributeError, [self, name] if value.nil? && !optional

      value = Id::Coercion.coerce(value, type, optional)
      value.tap { |value| instance_variable_set "@#{name}", value }
    end
  end

  private

end

class Id::MissingAttributeError < StandardError
  def initialize((model, name))
    super "#{model.class.name} had a nil value for '#{name}'."
  end
end
