# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movescount/version'

Gem::Specification.new do |spec|
  spec.name          = 'movescount'
  spec.version       = Movescount::VERSION
  spec.authors       = ['Stef Schenkelaars']
  spec.email         = ['stef.schenkelaars@gmail.com']

  spec.summary       = 'Api wrapper for Suunto movescount'
  spec.description   = 'Api wrapper for Suunto movescount'
  spec.homepage      = 'https://github.com/StefSchenkelaars/Movescount'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.14'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
end
