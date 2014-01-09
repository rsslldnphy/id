Gem::Specification.new do |s|
  s.name          = 'id'
  s.version       = '0.1.1'
  s.date          = '2013-03-28'
  s.summary       = "Simple models based on hashes"
  s.description   = "Easily convert hashes to Ruby objects. Originally developed at www.onthebeach.co.uk."
  s.authors       = ["Russell Dunphy", "Radek Molenda"]
  s.email         = ['rssll@rsslldnphy.com', 'radek.molenda@gmail.com']
  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage      = 'http://github.com/rsslldnphy/id'
  s.license       = 'MIT'

  s.add_dependency "optional"
  s.add_dependency "activesupport"
  s.add_dependency "activemodel"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "money"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "test-unit"


end
