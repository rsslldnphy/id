module Id::Field
  class Summary
    def initialize(definition)
      @definition = definition
    end

    def to_s
      [name, type, key, optional, default].compact.join("\n")
    end

    private
    attr_reader :definition

    def name
      "Name:\t\t#{definition.name}"
    end

    def type
      "Type:\t\t#{definition.type}" unless definition.type == Object
    end

    def key
      "Key in hash:\t#{definition.key}" unless definition.key == definition.name.to_s
    end

    def optional
      "Optional:\ttrue" if definition.optional?
    end

    def default
      default = definition.default
      "Default:\t#{default.is_a?(Proc) ? 'Lambda' : default}" unless default.nil?
    end
  end
end
