module Id::Field

  def field(name, options = {})
    definition = Definition.new(name, options)
    define_field!(definition)
    define_predicate!(definition)
    fields[name] = definition
  end

  def fields
    @fields ||= {}
  end

  private

  def self.extended(base)
    base.send(:define_method, :fields) { self.class.fields }
  end

  def define_field!(definition)
    send :define_method, definition.name do
      memoized = instance_variable_get "@#{definition.name}"
      return memoized unless memoized.nil?

      value = data.fetch(definition.key, definition.default!)
      value = Option[value] if definition.optional?

      fail Id::MissingAttributeError, [self, definition] if value.nil?

      value = Id::Coercion.coerce(value, definition.type)
      value.tap { |value| instance_variable_set "@#{definition.name}", value }
    end
  end

  def define_predicate!(definition)
    send :define_method, "#{definition.name}?" do
      begin
        value = send(definition.name)
        !!value && !value.is_a?(None)
      rescue Id::MissingAttributeError
        false
      end
    end
  end

end

class Id::MissingAttributeError < StandardError
  def initialize((model, field))
    super "#{model.class.name} had a nil value for '#{field.name}'.\n\n" +
          "### Field information ###\n#{field.to_s}\n\n" +
          "### Model data ###\n#{model.data.inspect}\n\n"
  end
end
