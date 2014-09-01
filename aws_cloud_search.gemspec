# -*- encoding: utf-8 -*-
require File.expand_path('../lib/aws_cloud_search/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Jensen", "Mike Javorski", 'Glenn Nagel']
  gem.email         = ["david.jensen@spoke.com", "mike.javorski@spoke.com", 'glenn.nagel@modaoperandi.com']
  gem.description   = %q{AWSCloudSearch Search gem}
  gem.summary       = %q{Implementation of the AWS CloudSearch API}
  gem.homepage      = "https://github.com/scramble/aws_cloud_search"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "aws_cloud_search"
  gem.require_paths = ["lib"]
  gem.version       = AWSCloudSearch::VERSION

  gem.add_dependency 'faraday_middleware', '>= 0.8.0'

  gem.add_development_dependency 'rake', '>= 0.9.2'
  gem.add_development_dependency 'rspec', '>= 2.6.0'
end
