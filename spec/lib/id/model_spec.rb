require 'spec_helper'

describe Id::Model do

  it 'is used by including the module' do
    c = Class.new { include Id::Model ; field :cats }.new(cats: 3)
    expect(c.cats).to eq 3
  end

end
