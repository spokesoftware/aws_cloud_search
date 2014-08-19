require 'rubygems'
require 'bundler/setup'

require 'aws_cloud_search'

raise "Missing ENV['CLOUDSEARCH_DOMAIN_V2011']" unless ENV['CLOUDSEARCH_DOMAIN_V2011']
raise "Missing ENV['CLOUDSEARCH_DOMAIN_V2013']" unless ENV['CLOUDSEARCH_DOMAIN_V2013']

RSpec.configure do |config|
end
