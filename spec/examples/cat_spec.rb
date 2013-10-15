require 'spec_helper'

class Mouse; include Id::Model end

class Cat
  include Id::Model

  field :name
  field :paws, type: Integer
  field :mice, type: Array[Mouse]
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

  it 'has an array of mice' do
    cat = Cat.new(mice: [{},{},{}])
    expect(cat.mice).to have(3).items
    cat.mice.each { |mouse| expect(mouse).to be_a Mouse }
  end

end
