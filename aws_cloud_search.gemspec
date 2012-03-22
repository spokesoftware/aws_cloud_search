# -*- encoding: utf-8 -*-
require File.expand_path('../lib/aws_cloud_search/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Jensen"]
  gem.email         = ["david.jensen@spoke.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "aws_cloud_search"
  gem.require_paths = ["lib"]
  gem.version       = AwsCloudSearch::VERSION

  # TODO: add some version numbers here
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'yajl-ruby'

  gem.add_development_dependency 'rspec'
end
