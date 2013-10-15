module Id::Model

  module InstanceMethods
    def initialize(data)
      @data = data
    end
    attr_reader :data
  end

  def self.included(base)
    warn "[DEPRECATION] Including `Id::Model` is deprecated; please extend it instead."
    base.extend(self) # for backwards compatibility
  end

  def self.extended(base)
    base.send(:include, InstanceMethods)
  end

  def field(name)
    send :define_method, name do
      data.fetch(name)
    end
  end

end
