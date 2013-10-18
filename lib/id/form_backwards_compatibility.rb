module Id::FormBackwardsCompatibility
  def form(&block)
    warn '[DEPRECATION] form is no longer needed - validation can be specified at the top level of the model'
    form_class.send :instance_exec, &block
  end
end
