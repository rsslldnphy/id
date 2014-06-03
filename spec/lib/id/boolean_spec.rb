require 'spec_helper'

describe Id::Boolean do
  it 'parses the word true as true' do
    b = Id::Boolean.parse('true')
    expect(b).to be_true
  end

  it 'parses the word yes as true' do
    b = Id::Boolean.parse('yes')
    expect(b).to be_true
  end

  it 'is case insensite when parsing a string' do
    b = Id::Boolean.parse('tRuE')
    expect(b).to be_true
  end

  it 'parses the character 1 as true' do
    b = Id::Boolean.parse('1')
    expect(b).to be_true
  end

  it 'parses the number 1 as true' do
    b = Id::Boolean.parse(1)
    expect(b).to be_true
  end

  it 'parses symbols as well as strings' do
    b = Id::Boolean.parse(:true)
    expect(b).to be_true
  end

  it 'parses trueclass as true' do
    b = Id::Boolean.parse(true)
    expect(b).to be_true
  end

  it 'parses everything else as false' do
    b = Id::Boolean.parse(:cottage_cheese)
    expect(b).to be_false
  end

  it 'works with default values' do
    test_class = Class.new { include Id::Model; field :foo, type: Id::Boolean, default: false }
    expect(test_class.new.foo).to be_false
  end

end
