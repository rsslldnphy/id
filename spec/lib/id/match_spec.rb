require 'spec_helper'

describe Id::Match do
  let (:c) { Class.new { include Id::Model; field :foo; field :bar } }

  context 'pattern matching over fields' do

    context 'when the field to match is not set' do
      it 'raises an error' do
        expect do
          result = c.new.match do |m|
            m.model(foo: 3) { "match on foo" }
          end
        end.to raise_error BadMatchError
      end
    end

    context 'when there is a match on a specific field' do
      it 'evaluates the corresponding block' do
        result = c.new(foo: 3).match do |m|
          m.model(foo: 3) { "match on foo" }
        end
        expect(result).to eq "match on foo"
      end
    end

    context 'when there is a wildcard match' do
      it 'evaluates the corresponding block if there are no other matches' do
        result = c.new(foo: 4).match do |m|
          m.model(foo: 3) { "match on foo"   }
          m._             { "wildcard match" }
        end
        expect(result).to eq "wildcard match"
      end

      it 'does not evaluate the wildcard block if there is a match' do
        result = c.new(foo: 3).match do |m|
          m.model(foo: 3) { "match on foo"   }
          m._             { "wildcard match" }
        end
        expect(result).to eq "match on foo"
      end
    end

    context 'when matching on more than one field' do
      it 'matches only if all queried fields match' do
        result = c.new(foo: 3, bar: 5).match do |m|
          m.model(foo: 3, bar: 6) { "match on foo"         }
          m.model(foo: 4, bar: 5) { "match on bar"         }
          m.model(foo: 3, bar: 5) { "match on foo and bar" }
          m._                     { "wildcard match"       }
        end
        expect(result).to eq "match on foo and bar"
      end
    end

    context 'matching based on type of a field' do
      it 'if a class is specified for a field, matches if that field is of that class' do
        result = c.new(foo: 3).match do |m|
          m.model(foo: String) { "matches string" }
          m.model(foo: Fixnum) { "matches fixnum" }
        end
        expect(result).to eq "matches fixnum"
      end
    end

    context 'matching based on regex' do
      it 'if a regex is specified for a field, matches if that field matches' do
        result = c.new(foo: "cat").match do |m|
          m.model(foo: /do?/) { "matches /do?/" }
          m.model(foo: /ca?/) { "matches /ca?/" }
        end
        expect(result).to eq "matches /ca?/"
      end
    end
  end

  context 'matching based on class' do

    class Cat
      include Id::Model
      field :name
    end

    it 'matches classes of the same name as the method called' do
      result = Cat.new.match do |m|
        m.cat { "matched cat" }
        m._   { "no match"    }
      end
      expect(result).to eq 'matched cat'
    end

    it 'matches based on a combination of class and contents' do
      result = Cat.new(name: "Terry").match do |m|
        m.cat(name: "Gerry")       { "matched gerry" }
        m.cat(name: "Terry")       { "matched terry" }
        m.cat(name: "Bryan Ferry") { "matched bryan ferry" }
      end
      expect(result).to eq 'matched terry'
    end
  end

  context 'using data internal to the model being matched' do
    it 'gives access to the internal data of the model when evaluating a match' do
      result = c.new(foo: 3, bar: 5).match do |m|
        m.model(foo: 3, bar: 6) { "match on foo"                    }
        m.model(foo: 4, bar: 5) { "match on bar"                    }
        m.model(foo: 3, bar: 5) { "foo is #{foo} and bar is #{bar}" }
        m._                     { "wildcard match"                  }
      end
      expect(result).to eq 'foo is 3 and bar is 5'
    end
  end

end
