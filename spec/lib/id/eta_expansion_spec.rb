require 'spec_helper'

class Foot
  include Id::Model
end

describe Id::EtaExpansion do
  it 'eta expands an id model class into its constructor' do
    feet = [{},{},{}].map(&Foot)
    expect(feet).to have(3).items
    feet.each { |foot| expect(foot).to be_a Foot }
  end
end
