require 'spec_helper'

describe Id::Field do

  it 'allows key aliases to be defined' do
    c = Class.new { include Id::Model ; field :cats, key: 'kittehs' }.new(kittehs: 3)
    expect(c.cats).to eq 3
  end

  it 'blows up with an informative error if you try to request a nil value' do
    class TestClass; include Id::Model; field :cats end
    c = TestClass.new
    expect { c.cats }.to raise_error Id::MissingAttributeError, /TestClass had a nil value for 'cats'./
  end

  describe 'type coercion' do

    it 'can coerce basic types' do
      c = Class.new { include Id::Model ; field :cats, type: Integer }.new(cats: "3")
      expect(c.cats).to eq 3
    end
  end

  describe 'defaults' do

    it 'can be initialised with a default value' do
      c = Class.new { include Id::Model ; field :cats, default: 7 }.new
      expect(c.cats).to eq 7
    end

    it 'can take a lambda as a default value' do
      c = Class.new { include Id::Model ; field :cats, default: -> { 7 } }.new
      expect(c.cats).to eq 7
    end

    it 'runs lambda defaults at the point of first access of the field' do
      c = Class.new { include Id::Model ; field :time, default: -> { Time.now } }.new
      d = Class.new { include Id::Model ; field :time, default: -> { Time.now } }.new
      t1 = c.time; sleep 0.0001; t2 = d.time
      expect(t2).to be > t1
    end

    it 'memoizes lambda generated values so they are created only once' do
      c = Class.new { include Id::Model ; field :time, default: -> { Time.now } }.new
      t1 = c.time; sleep 0.0001; t2 = c.time
      expect(t2).to eq t1
    end

  end

  it 'can test for the presence of values' do
    c = Class.new { include Id::Model ; field :foo }.new
    expect(c.foo?).to be_false
    d = c.set(foo: 4)
    expect(d.foo?).to be_true
  end

  it 'makes the fields of the model enumerable' do
    c = Class.new { include Id::Model ; field :foo }.new
    expect(c.fields.keys.map(&:to_s).map(&:upcase)).to eq ["FOO"]
  end
end
