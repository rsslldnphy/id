module Id::Form

  def active_model
    @active_model ||= form_class.new(self)
  end

  def as_form
    warn '[DEPRECATION] calling `as_form` is deprecated, please use `to_model` instead'
    to_model
  end

  private

  # Please, someone tell me how this can be made nicer as it makes me
  # want to puke everywhere :-(
  def self.included(base)
    base.send(:extend, ActiveModel::Naming)
    base.send(:include, ActiveModel::Conversion)
    base.send(:alias_method, :to_model, :active_model)

    base.define_singleton_method :form_class do
      base = self
      @form_class ||= Class.new(Id::ActiveModel) do
        eigenclass = class << self; self end
        eigenclass.send(:define_method, :model_name, &base.method(:model_name))
      end
    end
  end

  def form_class
    self.class.form_class
  end

end
