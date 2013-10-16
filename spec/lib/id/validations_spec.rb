require 'spec_helper'

describe Id::Validations do

  class ValidationModel
    include Id::Model
    include Id::Form

    field :cats
    validates_presence_of :cats
  end

  it 'delegates validations to the active model class' do
    model = ValidationModel.new
    expect(model).not_to be_valid
    expect(model.errors.messages).to eq ({ cats: ["can't be blank"] })
  end
end
