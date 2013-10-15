require 'spec_helper'

class Cat
  extend Id::Model

  field :name
  field :paws, type: Integer
end

describe Cat do
  it 'has a name' do
    cat = Cat.new(name: 'Tracy')
    expect(cat.name).to eq 'Tracy'
  end

  it 'has an integer number of paws' do
    cat = Cat.new(paws: '3')
    expect(cat.paws).to eq 3
  end
end
