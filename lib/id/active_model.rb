class Id::ActiveModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  def self.i18n_scope
    :id
  end

  def initialize(model)
    @model = model
  end

  def persisted?
    false
  end

  def to_model
    self
  end

  def to_partial_path
    model.respond_to?(:to_partial_path) ? model.to_partial_path : super
  end

  def respond_to?(name, include_private = false)
    super || model.respond_to?(name, include_private)
  end

  private

  def method_missing(name, *args, &block)
    model.send(name, *args, &block)
  end

  attr_reader :model
end
