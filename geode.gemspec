lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geode/version'

Gem::Specification.new do |spec|
  spec.name          = 'geode'
  spec.version       = Geode::VERSION
  spec.authors       = ['Rob Trame']
  spec.email         = ['rob@lunaticgarden.com']

  spec.summary       = 'A gem for geometric calculations on planets'
  spec.description   = 'Geode provides an easy way to work with points, ' \
                       'vectors, and shapes on the surface of planets.'
  spec.homepage      = 'https://gitlab.com/redapted/geode'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/geode.rb'] + Dir['test/**/test_*.rb']
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
end
