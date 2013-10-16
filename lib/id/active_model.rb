class Id::ActiveModel
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def self.i18n_scope
    :id
  end

  def initialize(model)
    @model = model
  end

  def persisted?
    true
  end

  def to_partial_path
    model.respond_to?(:to_partial_path) ? model.to_partial_path : super
  end

  def respond_to?(name, include_private = false)
    super || model.respond_to?(name, include_private)
  end

  private

  def method_missing(name, *args, &block)
    field = model.fields[name]
    field.nil? ? model.send(name, *args, &block) : model.data[field.key]
  end

  attr_reader :model
end