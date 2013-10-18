require 'spec_helper'

module Id::Field
  describe Summary do
    it 'constructs a summary of the definition' do
      definition = Id::Field::Definition.new(:cats,
                                             optional: true,
                                             key: 'kittens',
                                             type: String,
                                             default: -> { "KITTEH!"})
      summary = definition.to_s
      expect(summary).to eq "Name: cats\n"   +
                            "Type: String\n" +
                            "Key in hash: kittens\n" +
                            "Optional: true\n" +
                            "Default: Lambda"
    end

    it 'omits info for options that are not specified' do
      definition = Id::Field::Definition.new(:cats, type: String)
      summary = definition.to_s
      expect(summary).to eq "Name: cats\n"   +
                            "Type: String"
    end
  end
end
