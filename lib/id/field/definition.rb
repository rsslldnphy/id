module Id::Field
  class Definition
    def initialize(name, options)
      @name = name
      @options = options
    end

    def default
      options.fetch(:default, nil)
    end

    def default!
      default.is_a?(Proc) ? default.call : default
    end

    def key
      options.fetch(:key, name).to_s
    end

    def type
      options.fetch(:type, Object)
    end

    def optional?
      options.fetch(:optional, false)
    end

    def to_s
      Id::Field::Summary.new(self).to_s
    end

    def value(data)
      # the following code is a bit verbose but can't use || as false is valid here
      value = data[key]
      value = data[key.to_sym] if value.nil?
      value = default!         if value.nil?
      value = Option[value]    if optional?

      Id::Coercion.coerce(value, type) unless value.nil?
    end

    attr_reader :name, :options
  end
end
