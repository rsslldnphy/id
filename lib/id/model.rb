module Id::Model

  def self.[](*keys)
    Class.new do
      include Id::Model
      keys.each { |key| field key }
    end
  end

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

  def ===(other)
    match = other.is_a?(Id::Model) ? other.data : other
    match.all? do |k, v|
      field = fields[k]
      if field.present?
        value = field.value(data)
        v.is_a?(Hash) && value.is_a?(Id::Model) ? value === v : v === value
      end
    end
  end

  def eql?(other)
    other.is_a?(Id::Model) && other._data.eql?(self._data)
  end
  alias_method :==, :eql?

  def hash
    _data.hash
  end

  def data
    @data ||= Id::Hashifier.enhash(_data)
  end

  def match(&block)
    Id::Match.new(self)._evaluate(&block)
  end

  alias to_hash data

  def juxt(*methods)
    methods.map { |m| m.to_proc.call(self) }
  end

  protected
  attr_reader :_data

  def self.included(base)
    base.send :extend, Id::Field, Id::Association, Id::EtaExpansion
  end
end
