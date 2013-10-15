module Id::Model

  def initialize(_data = {})
    @_data = _data
  end

  def data
    @data ||= _data.reduce({}) { |acc, (k, v)| acc.merge(k.to_s => v) }
  end

  private
  attr_reader :_data

  def self.included(base)
    base.send :extend, Id::Field
    base.send :extend, Id::Association
  end
end
