require 'spec_helper'

describe Id::Model do

  it 'is used by including the module' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
  end

  it 'can have fields set on it after creation - creating a new instance' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
    d = c.set(cats: 4)
    expect(c.cats).to eq 3
    expect(d.cats).to eq 4
  end
end
