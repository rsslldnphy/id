module Id::Form

  def active_model
    @active_model ||= form_class.new(self)
  end

  def as_form
    warn '[DEPRECATION] calling `as_form` is deprecated, please use `to_model` instead'
    to_model
  end

  delegate :valid?, :errors, to: :active_model

  private
  def form_class
    self.class.form_class
  end

  def self.included(base)
    base.send :include, ActiveModel::Conversion
    base.send :extend,  ActiveModel::Naming, Id::Validations
    base.send :alias_method, :to_model, :active_model

    base.define_singleton_method :form_class do
      base = self
      @form_class ||= Class.new(Id::ActiveModel) do
        eigenclass = class << self; self end
        eigenclass.send(:define_method, :model_name, &base.method(:model_name))
      end
    end
  end

end