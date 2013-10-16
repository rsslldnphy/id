module Id::Form

  def active_model
    @active_model ||= Id::ActiveModel.new(self)
  end
  alias_method :to_model, :active_model

  def as_form
    warn '[DEPRECATION] calling `as_form` is deprecated, please use `to_model` instead'
    to_model
  end

end
