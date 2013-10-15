require 'spec_helper'

describe Id::Coercion do

  it 'can coerce basic types' do
    coerced = Id::Coercion.coerce("2", Integer)
    expect(coerced).to eq 2
  end

  it 'can have new coercions added, even stupid ones' do
    Id::Coercion.register(Fixnum, String) { |value| (value + 1).to_s }
    coerced = Id::Coercion.coerce(2, String)
    expect(coerced).to eq "3"
  end

  it 'throws an error if there is no registered coercion for the given types' do
    expect { Id::Coercion.coerce(2, Proc) }.to raise_error Id::CoercionError
  end

  it 'can coerce data into Id::Models' do
    c = Class.new { extend Id::Model ; field :cats }
    coerced = Id::Coercion.coerce({cats: 3}, c)
    expect(coerced.cats).to eq 3
  end
end
