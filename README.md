# id
### simple models based on hashes

JSON is a great way to transfer data between systems, and it's easy to parse into a Ruby hash. But sometimes it's nice to have actual methods to call when you want to get attributes from your data, rather than coupling your entire codebase to the hash representation by littering it with calls to `fetch` or `[]`. The same goes for BSON documents stored in Mongo.

That's where `id` (as in Freud) comes in. You define your model classes using syntax that should look pretty familiar if you've used any popular Ruby ORMs - but `id` is not an ORM. Model objects defined with `id` have a constructor that accepts a hash, and you define the values of this hash that are made readable as fields, but that hash can come from any source.

#### Defining a model

To define a model, include the `Id::Model` module in your class.

```ruby
class Cat
  include Id::Model
end
```

#### Defining fields

At its most basic, you can define a field like this:

```ruby
class Cat
  field :name
end
```

This gives you the equivalent of an `attr_reader` for that field, as well as a predicate method which checks if it has been set (in the case of boolean fields, this predicate method also checks the value of that field - nil is interpreted as false).

```ruby
cat = Cat.new(name: "Travis")
cat.name  # => "Travis"
cat.name? # => true

cat = Cat.new
cat.name? # => false
```

###### What happens if you try to access a field that hasn't been set?

```ruby
irb(main):007:0> Cat.new.name
  Id::MissingAttributeError: Cat had a nil value for 'name'.
```
Id is allergic to `nil`, and refuses to return it. If you want to access a field you need to be sure it's there, or you'll get an error. This means if you have a bug in your code and a field isn't set, you'll find out as soon as possible, rather that letting a `nil` leak out and cause an `undefined method 'foo' for nil:NilClass` at some unspecified future point, from where it might be hard to track down the source of the problem.

###### What about optional fields?

Sometimes fields really are optional. In this case you can either test for their presence using the predicate methods (which is a bit ugly, but at least forces you to deal with the empty case), or you can mark the field as `optional: true`, which will make them return an `Option` type rather than a raw value.

`Option` types are a pattern found in many functional languages (the `Option` type in Scala, the `Maybe` monad in Haskell) and the Ruby implementation used by id can be found [here](http://github.com/rsslldnphy/optional).

###### Can I set default values?

Yes. Default values are specified like this:

```ruby
class Cat
  ...
  field :paws, default: 4
end

Cat.new.paws # => 4
```

You can also specify lambda defaults. These will be run on initialization of an instance of your model.

```ruby
class Cat
  ...
  field :birthday, default: -> { Date.new }
end

Cat.new.birthday # => #<Date: 2013-10-21 ((2456587j,0s,0n),+0s,2299161j)>
```

###### I don't like the key names in my data-source :-(

We don't always get what we want. But don't despair! If the hash you're using to create your models has badly named keys - e.g., horror of horrors, keys in camelCase - you can use key aliases to convert them to nice, succinct, Rubyish identifiers:

```ruby
class Camel
  include Id::Model

  field :name,  key: 'camelName'
  field :humps, key: 'camelHumps'
end

Camel.new('camelName' => 'Terry').name # => "Terry"
```

#### Type Coercion

Id can coerce your fields into a number of basic types. Just specify the type you want as part of the field definition.

```ruby
class Cat
  ...
  field :paws, type: Integer
end

Cat.new(paws: "3").paws => 3
Cat.new(paws: "3").paws.class => Integer
```

You can typecast array elements like this:

```ruby
field :counts, type: Array[Integer]
```

Because Ruby doesn't have a `Boolean` type (weird, right?), if you want to coerce something to either `true` or `false`, you need to use `Id::Boolean`, like this:

```ruby
field :admin, type: Id::Boolean
```

And if you need to coerce a type id doesn't yet support, such as a custom type of your own, you can register new coercions by passing the "from" type, "to" type, and a block to perform the conversion to `Id::Coercion.register`.

```ruby
Id::Coercion.register String, Money do |value|
  value.to_money
end
```
or more succinctly:

```ruby
Id::Coercion.register String, Money, &:to_money
```

#### Associations

If you have nested arrays or hashes in your source, you can define id models for them in turn, and treat them much like you would associations in an ORM, by defining them as `has_one` or `has_many` associations on the parent model.

```ruby
class Lion
  include Id::Model
  field :name
end

class Person
  include Id::Model
  field :name
end

class Zoo
  include Id::Model

  has_many :lions
  has_one :zookeeper, type: Person
end

zoo = Zoo.new(lions: [{name: 'Hetty'}],
              zookeeper: {name: 'Russell'})

zoo.lions.first.class # => Lion
zoo.lions.first.name  # => "Hetty"
zoo.zookeeper.class   # => Person
zoo.zookeeper.name    # => "Russell"
```

Types are inferred from the association name unless specified.

#### Designed for immutability

`id` models provide accessor methods, but no mutator methods, because they are designed for immutability. How do immutable models work? When you need to change some field of a model object, a new copy of the object is created with the field changed as required. This is handled for you by `id`'s `set` method:

```ruby
person1 = Person.new(name: 'Russell', job: 'programmer')
person2 = person1.set(name: 'Radek')
person1.name # => 'Russell'
person2.name # => 'Radek'
person2.job  # => 'programmer'
```

Obviously, this is Ruby, and if you really want to mutate some of the internal state of an id model you will be able to find a way to do it. Don't do it!

#### Id and Rails

We might not love everything about Rails, but we probably use it at least some of the time. So does id play nicely with it?

With a few modifications, yes. Models that blow up at the sight of `nil` don't play happy with Rails' `nil`-happy forms, but you can make your id models active model compliant in forms, while otherwise retaining the `nil`-allergy in the rest of your code, by doing two things.

Include the `Id::Form` module in your model.

```ruby
class Cat
  include Id::Model
  include Id::Form
end
```

Add the following line to `config/application.rb`:

```ruby
config.action_view.default_form_builder = Id::FormBuilder
```

With `Id::Form` included you can use Active Model validations as normal, and override methods like `to_partial_path`, `self.model_name`, and `persisted?` right there in your model.

### Timestamps

And finally, it's reasonably common to want to know when a particular model was created and/or updated. Id provides you this functionality out of the box through the `Id::Timestamps` module. Just include it to your model to get `created_at` and `updated_at` fields that behave as you would expect.
