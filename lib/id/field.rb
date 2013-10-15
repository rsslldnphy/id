module Id::Field

  def field(name, options = {})
    send :define_method, name do
      memoized = instance_variable_get "@#{name}"
      return memoized unless memoized.nil?

      key      = options.fetch(:key, name.to_s)
      default  = options.fetch(:default, nil)
      default  = default.call if default.is_a? Proc

      data.fetch(key, default).tap do |value|
        instance_variable_set "@#{name}", value
      end or fail Id::MissingAttributeError, [self, name]
    end
  end

end

class Id::MissingAttributeError < StandardError
  def initialize(cause)
    model, name = cause
    super "#{model.class.name} had a nil value for '#{name}'."
  end
end
