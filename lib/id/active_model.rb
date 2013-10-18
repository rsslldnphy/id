class Id::ActiveModel
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def self.i18n_scope
    :id
  end

  def initialize(model, data)
    @model = model
    @data = data
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
    field.nil? ? model.send(name, *args, &block) : data[field.key]
  end

  attr_reader :model, :data
end
