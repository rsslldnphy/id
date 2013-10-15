module Id::Model

  def initialize(data = {})
    @data = Id::Hashify.enhash(data)
  end

  def set(update)
    self.class.new data.merge(update)
  end

  attr_reader :data
  alias_method :to_hash, :data

  def self.included(base)
    base.send :extend, Id::Field
    base.send :extend, Id::Association
    base.send :extend, Id::EtaExpansion
  end
end
