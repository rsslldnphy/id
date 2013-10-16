module Id::Boolean
  extend self

  def parse(value)
    ['yes', 'true', '1'].include?(value.to_s.downcase)
  end

end
