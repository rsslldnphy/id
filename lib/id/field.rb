module Id::Field

  def field(name, options = {})
    define_field!(name, options)
    define_predicate!(name)
  end

  private

  def define_field!(name, options)
    send :define_method, name do
      memoized = instance_variable_get "@#{name}"
      return memoized unless memoized.nil?

      key      = options.fetch(:key, name.to_s)
      type     = options.fetch(:type, Object)

      default  = options.fetch(:default, nil)
      default  = default.call if default.is_a? Proc

      value = data.fetch(key, default)
      value = Option[value] if options.fetch(:optional, false)

      fail Id::MissingAttributeError, [self, name] if value.nil?

      value = Id::Coercion.coerce(value, type)
      value.tap { |value| instance_variable_set "@#{name}", value }
    end
  end

  def define_predicate!(name)
    send :define_method, "#{name}?" do
      begin
        value = send(name)
        !!value && !value.is_a?(None)
      rescue Id::MissingAttributeError
        false
      end
    end
  end

end

class Id::MissingAttributeError < StandardError
  def initialize((model, name))
    super "#{model.class.name} had a nil value for '#{name}'."
  end
end
