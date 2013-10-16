require 'spec_helper'
require 'support/active_model_lint'

class ActiveModelTest
  include Id::Model
  include Id::Form

  field :sheep

  def wrapped_in_plastic?
    true
  end
end

describe ActiveModelTest do

  subject { ActiveModelTest.new.to_model }

  it_behaves_like "ActiveModel"

  it 'has an I18n scope of id' do
    expect(ActiveModelTest.new.to_model.class.i18n_scope).to eq :id
  end

  it 'can return the fields of the model' do
    model = ActiveModelTest.new(sheep: 42).to_model
    expect(model.sheep).to eq 42
  end

  it "doesn't blow up for nil fields" do
    model = ActiveModelTest.new.to_model
    expect(model.sheep).to be_nil
  end

  it 'delegates method calls to the original model' do
    model = ActiveModelTest.new.to_model
    expect(model).to be_wrapped_in_plastic
  end

end
