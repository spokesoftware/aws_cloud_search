require 'rubygems'
require 'bundler/setup'

require 'aws_cloud_search'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end