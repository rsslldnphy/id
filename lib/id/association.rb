module Id::Association

  def has_one(name, options = {})
    type    = options[:type] || infer_class(name)
    options = options.merge(type: type)
    field name, options
  end

  def has_many(name, options = {})
    type    = Array[options[:type] || infer_class(name)]
    options = options.merge(type: type)
    field name, options
  end

  private

  def infer_class(name)
    name = name.to_s.singularize.classify
    if const_defined?(name)
      const_get(name)
    else
      parent = self.name.sub(/::[^:]+$/, '')
      parent.constantize.const_get(name)
    end
  end
end
