require 'spec_helper'

describe Id::Model do

  it 'is used by including the module' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
  end

  describe 'square bracket shorthand' do
    it 'allows models to be defined succintly' do
      Thingy = Id::Model[:foo, :bar, :baz]
      thingy = Thingy.new(foo: 1, bar: 2, baz: 3)
      expect(thingy).to be_an Id::Model
      expect(thingy.foo).to eq 1
      expect(thingy.bar).to eq 2
      expect(thingy.baz).to eq 3
    end
  end

  it 'can have fields set on it after creation - creating a new instance' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
    d = c.set(cats: 4)
    expect(c.cats).to eq 3
    expect(d.cats).to eq 4
  end

  it 'can have fields removed from it after creation - creating a new instance' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
    d = c.unset(:cats)
    expect(c.cats).to eq 3
    expect { d.cats }.to raise_error Id::MissingAttributeError
  end

  it 'is equal to models with the same data' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    d = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c).to eq d
  end

  it 'is not equal to models with different data' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    d = Class.new { include Id::Model ; field :cats }.new(cats: 4)
    expect(c).not_to eq d
  end

  it 'can be used as keys in a hash' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    d = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    e = Class.new { include Id::Model ; field :cats }.new(cats: 4)
    hash = { c => 10, e => 12 }
    expect(hash[d]).to eq 10
    expect(hash[e]).to eq 12
  end

  describe '#juxt' do
    it 'calls each of the passed functions on its value, returning an array of the results' do
      c = Class.new { include Id::Model ; field :cats; field :dogs }.new(cats: 3, dogs: 5)
      result = c.juxt(:cats, :dogs, ->(x){ x.cats * x.dogs })
      expect(result).to eq [3, 5, 15]
    end
  end
end
