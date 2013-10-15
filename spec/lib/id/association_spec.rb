require 'spec_helper'

class Tail
  include Id::Model
  field :waggy
end

class Dog
  include Id::Model
  has_one :tail

  class Nose
    include Id::Model
    field :wet
  end
  has_one :nose

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
  end
end
