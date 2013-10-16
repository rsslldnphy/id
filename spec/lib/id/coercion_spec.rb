require 'spec_helper'

describe Id::Coercion do

  it 'can coerce basic types' do
    coerced = Id::Coercion.coerce("2", Integer)
    expect(coerced).to eq 2
  end

  it 'can coerce strings into dates' do
    coerced = Id::Coercion.coerce("01/01/2001", Date)
    expect(coerced).to eq Date.new(2001, 1, 1)
  end

  it 'can coerce strings into times' do
    coerced = Id::Coercion.coerce("01/01/2001", Time)
    expect(coerced).to eq Time.new(2001, 1, 1)
  end

  it 'can coerce strings into booleans' do
    coerced = Id::Coercion.coerce("yes", Id::Boolean)
    expect(coerced).to be_true
  end

  it 'can have new coercions added, even stupid ones' do
    Id::Coercion.register(Fixnum, String) { |value| (value + 1).to_s }
    coerced = Id::Coercion.coerce(2, String)
    expect(coerced).to eq "3"
  end

  it 'throws an error if there is no registered coercion for the given types' do
    expect { Id::Coercion.coerce(2, Proc) }.to raise_error Id::CoercionError
  end

  it 'can coerce data into id models' do
    c = Class.new { include Id::Model ; field :cats }
    coerced = Id::Coercion.coerce({cats: 3}, c)
    expect(coerced.cats).to eq 3
  end

  it 'can coerce arrays of a type' do
    c = Class.new { include Id::Model }
    coerced = Id::Coercion.coerce([{},{},{}], Array[c])
    expect(coerced).to have(3).items
    coerced.each { |item| expect(item).to be_a c }
  end

  it 'can coerce optional types' do
    c = Class.new { include Id::Model; field :foot, optional: true, type: Integer }
    expect(c.new.foot).to be_none
    expect(c.new(foot: '4').foot).to eq Some[4]
  end
end
