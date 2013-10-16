require 'spec_helper'

module Id::Field
  describe Definition do

    it 'has a name' do
      definition = Definition.new(:cats, {})
      expect(definition.name).to eq :cats
    end

    it 'can be optional' do
      definition = Definition.new(:cats, optional: true)
      expect(definition).to be_optional
    end

    it 'has a type' do
      definition = Definition.new(:cats, type: String)
      expect(definition.type).to eq String
    end

    it 'has a string key' do
      definition = Definition.new(:cats, key: 'kitten')
      expect(definition.key).to eq 'kitten'
    end

    it 'has a default' do
      definition = Definition.new(:cats, default: ->{ Time.now })
      expect(definition.default).to be_a Proc
    end

    it 'has a default! method which executes the default if it is a lambda' do
      definition = Definition.new(:cats, default: ->{ Time.now })
      expect(definition.default!).to be_a Time
    end

  end
end
