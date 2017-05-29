# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phoenix_password/version'

Gem::Specification.new do |spec|
  spec.name          = "phoenix_password"
  spec.version       = PhoenixPassword::VERSION
  spec.authors       = ["Spiros Avlonitis"]
  spec.email         = ["spirosa84@hotmail.com"]

  spec.summary       = %q{PhoenixPassword is an all purpose password genrator.}
  spec.description   = %q{Phoenix password generator provides you with several options for generating passwords, which characters are to be used,combination length,character uniqueness etc.}
  spec.homepage      = "https://github.com/spirosavlonitis/phoenix_password"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
