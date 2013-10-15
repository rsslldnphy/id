module Id::Model

  def initialize(_data = {})
    @_data = _data
  end

  def to_hash
    Id::Hashify.enhash(_data)
  end
  alias_method :data, :to_hash

  private
  attr_reader :_data

  def self.included(base)
    base.send :extend, Id::Field
    base.send :extend, Id::Association
    base.send :extend, Id::EtaExpansion
  end
end
