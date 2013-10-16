require 'spec_helper'

describe Id::Form do

  class FormTest
    include Id::Model
    include Id::Form
  end

  it 'defines self.model_name' do
    expect(FormTest.new.to_model.class.model_name).to eq 'FormTest'
  end

  class FormTest2
    include Id::Model
    include Id::Form

    def self.model_name
      'Harry'
    end
  end

  it "defers to the class' implementation of model_name if it has one" do
    expect(FormTest2.new.to_model.class.model_name).to eq 'Harry'
  end

  class FormTest3
    include Id::Model
    include Id::Form

    def to_partial_path
      'Jemima'
    end
  end

  it "defers to the class' implementation of to_partial_path if it has one" do
    expect(FormTest3.new.to_model.to_partial_path).to eq 'Jemima'
  end

  class Octopus
    include Id::Model
    include Id::Form
  end

  it 'defines a sensible default implementation of to_partial_path' do
    expect(Octopus.new.to_model.to_partial_path).to eq 'octopi/octopus'
  end

  it 'still allows the use of as_form, but this is deprecated' do
    octopus = Octopus.new
    expect(octopus.as_form).to eq octopus.to_model
  end
end
