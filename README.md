# AWSCloudSearch

## Description

This gem is an implementation of the [Amazon Web Service CloudSearch API](http://aws.amazon.com/cloudsearch/).

The AWS CloudSearch service is comprised of three API end-points:

* search
* document batching
* configuration

This gem currently supports only the search and document batching APIs. To access the CloudSearch configuration API from Ruby, use the [aws-sdk gem](https://github.com/aws/aws-sdk-ruby).

## Roadmap

Spoke developed this library in a short period of time in order to migrate from [IndexTank](https://github.com/linkedin/indextank-engine) to AWS CloudSearch. As such, there are a few features that are missing that we would like to build over time.

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

*Note*: work in progress


## Tests

The tests are pretty horrible right now, you need to create a working cloudsearch instead for both the 2011-02-01 and
2013-01-01 API versions with the following fields

    name: test
    type: text
    summary: text
    num_links: uint/int

then specify both domain in env variables when running the test

    CLOUDSEARCH_DOMAIN_V2011=test-gem-domain-bwasbvubrj4kmybx5gyfgu5vfq CLOUDSEARCH_DOMAIN_V2013=test-gem-domain-new-laem2ao4v2uki43idjertzbxye bundle exec rake spec


###Initialize the library

```ruby
# configure the gem, all three are required
AWSCloudSearch.configure do |config|
  config.domain = 'domain-bwasbvubrj4kmybx5gyfgu5vfq'
  config.region = 'us-east-1'
  config.api_version = '2011-02-01'
end

# inititalize the data store
ds = AWSCloudSearch::CloudSearch.new
```

###Create some documents
Since AWS charges per batch, it is best to batch as many documents as you can in each batch. `Document#new` takes an optional parameter `auto_version` which you set to true to automatically set the version, the default value is false.

```ruby
doc1 = AWSCloudSearch::Document.new(true)
doc1.id = '12345677890abcdef'
doc1.lang = 'en'
doc1.add_field('name', 'Jane Williams')
doc1.add_field('type', 'person')

doc2 = AWSCloudSearch::Document.new(true)
doc2.id = '588687626634767634'
doc2.lang = 'en'
doc2.add_field :name, 'Bob Dobalina'
doc2.add_field :type, 'person'
```

###Add documents to a new document batch

```ruby
batch = AWSCloudSearch::DocumentBatch.new    
batch.add_document doc1
batch.add_document doc2
```

###Include document deletes to your document batch
```ruby
doc3 = AWSCloudSearch::Document.new(true)
doc3.id = 'fedcba0987654321'
batch.delete_document doc3
```

###Send the document batch

```ruby
ds.documents_batch(batch)
```

###Searching Text Fields with the Query Parameter
See the [related CloudSearch documentation](http://docs.aws.amazon.com/cloudsearch/latest/developerguide/searching.text.html#searching.text.q)

````ruby
search_request = AWSCloudSearch::SearchRequest.new
search_request.q = "Bob"
search_results = ds.search(search_request)
search_results.hits.each do |hit|
  puts hit['id']
  puts hit['name']
end
````

###Searching Literal Fields with a Boolean Query
See the [related CloudSearch documentation](http://docs.aws.amazon.com/cloudsearch/latest/developerguide/searching.literal.html)

```ruby
search_request = AWSCloudSearch::SearchRequest.new
search_request.bq = "type:'person'"
search_results = ds.search(search_request)
search_results.hits.each do |hit|
  puts hit['id']
  puts hit['name']
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Version History

0.0.5 Added simple support for changing API version (luke_redoot)
0.0.2 Added support for faceting

## See Also
* [cloud_search gem](https://github.com/willian/cloud_search): another Ruby wrapper for the CloudSearch API
* [asari gem](https://github.com/duwanis/asari): and another Ruby wrapper for the CloudSearch API
* [aws-sdk gem](https://github.com/aws/aws-sdk-ruby): Amazon's official Ruby wrapper for AWS APIs
