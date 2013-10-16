module Id::Validations
  delegate :validate,              to: :form_class
  delegate :validates,             to: :form_class
  delegate :validates!,            to: :form_class
  delegate :validates_each,        to: :form_class
  delegate :validates_with,        to: :form_class
  delegate :validates_presence_of, to: :form_class
end
