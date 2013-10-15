require 'spec_helper'

class Tail; include Id::Model; field :waggy end
class Paw;  include Id::Model end

class Dog
  include Id::Model
  has_one :tail
  has_many :paws

  class Nose; include Id::Model; field :wet end
  has_one :nose

  class Poo; include Id::Model end
  has_many :poos
end

module Clothing
  class Button; include Id::Model end
  class Coat
    include Id::Model
    has_many :buttons
  end
  class Lapel
    include Id::Model
    has_one :button
  end
end

describe Id::Association do

  describe '#has_one' do

    it 'infers its type' do
      dog = Dog.new(tail: { waggy: true })
      expect(dog.tail).to be_a Tail
      expect(dog.tail.waggy).to be_true
    end

    it 'can deal with types nested inside the model class' do
      dog = Dog.new(nose: { wet: true })
      expect(dog.nose).to be_a Dog::Nose
      expect(dog.nose.wet).to be_true
    end

    it 'can deal with types nested inside a parent module' do
      lapel = Clothing::Lapel.new(button: {})
      expect(lapel.button).to be_a Clothing::Button
    end

  end

  describe '#has_many' do
    it 'infers its type' do
      dog = Dog.new(paws: [{}, {}, {}])
      expect(dog.paws).to have(3).items
      dog.paws.each { |paw| expect(paw).to be_a Paw }
    end

    it 'can deal with types nested inside the model class' do
      dog = Dog.new(poos: [{}, {}, {}])
      expect(dog.poos).to have(3).items
      dog.poos.each { |poo| expect(poo).to be_a Dog::Poo }
    end

    it 'can deal with types nested inside a parent module' do
      coat = Clothing::Coat.new(buttons: [{}, {}, {}])
      expect(coat.buttons).to have(3).items
      coat.buttons.each { |button| expect(button).to be_a Clothing::Button }
    end

  end
end
