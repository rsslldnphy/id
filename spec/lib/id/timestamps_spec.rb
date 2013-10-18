require 'spec_helper'

describe Id::Timestamps do
  let (:c) { Class.new { include Id::Model; include Id::Timestamps; field :foo } }

  let (:created) { Time.parse('2013-10-18 09:52:05 +0100') }
  let (:updated) { Time.parse('2013-10-18 09:57:35 +0100') }

  before do
    Time.stubs(:now).returns(created, updated)
  end

  it 'sets the created_at at creation' do
    expect(c.new.created_at).to be created
  end

  it 'sets the updated_at at creation' do
    expect(c.new.updated_at).to be created
  end

  it 'sets the updated_at after set is called' do
    expect(c.new.set(foo: 3).updated_at).to be updated
  end

  it 'sets the updated_at after unset is called' do
    expect(c.new(foo: 3).unset(:foo).updated_at).to be updated
  end

  it 'does not re-set the created_at when the model is updated' do
    expect(c.new.set(foo: 3).created_at).to be created
  end

end
