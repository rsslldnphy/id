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
      options.fetch(:key, name.to_s)
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

    attr_reader :name, :options
  end
end
