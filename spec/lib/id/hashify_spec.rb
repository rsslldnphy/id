require 'spec_helper'

describe Id::Hashify do

  it 'enhashes nested hashes of id models' do
    t = Class.new { include Id::Model }
    c = Class.new { include Id::Model ; has_one :tail, type: t }
    cat = c.new(tail: {waggy: false})
    expect(Id::Hashify.enhash cat).to eq("tail" => { "waggy" => false })
  end

  it 'enhashes nested arrays of id models' do
    p = Class.new { include Id::Model }
    c = Class.new { include Id::Model ; has_many :paws, type: p }
    cat = c.new(paws: [{},{},{}])
    expect(Id::Hashify.enhash cat).to eq("paws" => [{},{},{}])
  end

end
