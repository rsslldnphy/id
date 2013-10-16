module Id::Model

  def initialize(data = {})
    @data = Id::Hashify.enhash(data)
  end

  def set(update)
    update  = Id::Hashify.enhash(update)
    updated = data.merge(update)
    self.class.new(updated)
  end

  def unset(*fields)
    fields  = fields.map(&:to_s)
    updated = data.except(*fields)
    self.class.new(updated)
  end

  def eql? other
    other.is_a?(Id::Model) && other.data.eql?(self.data)
  end
  alias_method :==, :eql?

  def hash
    data.hash
  end

  attr_reader :data
  alias_method :to_hash, :data

  def self.included(base)
    base.send :extend, Id::Field
    base.send :extend, Id::Association
    base.send :extend, Id::EtaExpansion
  end
end
