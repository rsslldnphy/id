require 'spec_helper'

describe Id::Model do

  it 'is extended by implementing classes' do
    c = Class.new { extend Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
  end

  it 'still works by inclusion, but this is deprecated' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
  end

end
