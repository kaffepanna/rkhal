# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rkhal"
  spec.version       = `git describe --abbrev=0 --tags` 
  spec.authors       = ["Patrik Pettersson"]
  spec.email         = ["patrik.pettersson@ericsson.com"]

  spec.summary       = %q{Simple program to show the weeks agenda from exchange}
  spec.description   = %q{Simple program to show the weeks agenda from exchange}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'viewpoint'
  spec.add_runtime_dependency 'activesupport'
end
