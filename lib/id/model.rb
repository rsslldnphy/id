module Id::Model

  def self.included(base)
    warn "[DEPRECATION] Including `Id::Model` is deprecated; please extend it instead."
    base.extend(self) # for backwards compatibility
  end

  def self.extended(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def initialize(_data = {})
      @_data = _data
    end

    def data
      @data ||= _data.reduce({}) { |acc, (k, v)| acc.merge(k.to_s => v) }
    end

    private
    attr_reader :_data
  end

  include Id::Field
end
