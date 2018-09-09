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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
end
