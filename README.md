# AWSCloudSearch

## Description

This gem is an implementation of the Amazon Web Service CloudSearch API (http://aws.amazon.com/cloudsearch/).

The AWS CloudSearch service is comprised of three API end points: search, document batching, and configuration. This gem
currently supports only the search and document batching APIs

## Roadmap

Spoke developed this library in a short period of time in order to migrate from IndexTank to AWS CloudSearch.
As such, there are a few features that are missing that we would like to build over time.

+ Implementation of the configuration API
+ Query builder
+ Faceting helpers
+ Spec tests that stub the AWS CloudSearch service
+ Sample usage in this README

## Installation

Add this line to your application's Gemfile:

    gem 'aws_cloud_search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_cloud_search

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
