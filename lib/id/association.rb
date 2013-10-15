module Id::Association

  def has_one(name, options = {})
    type    = const_get name.to_s.classify
    options = { type: type }.merge(options)
    field name, options
  end

end
