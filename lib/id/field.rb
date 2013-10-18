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
      _data[definition.key] or fail Id::MissingAttributeError, [self, definition]
    end
  end

  def define_predicate!(definition)
    send :define_method, "#{definition.name}?" do
      value = _data[definition.key]
      value && !value.is_a?(None)
    end
  end

end

class Id::MissingAttributeError < StandardError
  def initialize((model, field))
    super "#{model.class.name} had a nil value for '#{field.name}'.\n\n" +
          "*** Field information ***\n#{field.to_s}\n\n" +
          "*** Model data ***\n#{model.data.inspect}\n\n" +
          "If you're trying to use an Id::Model in a Rails form, make sure:\n" +
          "* You 'include Id::Form' in your model\n" +
          "* You have the following line in your 'config/application.rb': \n\n" +
          "    config.action_view.default_form_builder = Id::FormBuilder\n\n"

  end
end
