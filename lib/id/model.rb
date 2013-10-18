module Id::Model

  def initialize(_data = {})
    @_data = fields.reduce({}) do |acc, (_, field)|
      acc.merge(field.key => field.value(_data))
    end
  end

  def set(update)
    updated = _data.merge(update.stringify_keys)
    self.class.new(updated)
  end

  def unset(*fields)
    fields  = fields.map(&:to_s)
    updated = _data.except(*fields)
    self.class.new(updated)
  end

  def eql? other
    other.is_a?(Id::Model) && other._data.eql?(self._data)
  end
  alias_method :==, :eql?

  def hash
    _data.hash
  end

  def data
    @data ||= Id::Hashifier.enhash(_data)
  end

  alias_method :to_hash, :data

  protected
  attr_reader :_data

  def self.included(base)
    base.send :extend, Id::Field, Id::Association, Id::EtaExpansion
  end
end
