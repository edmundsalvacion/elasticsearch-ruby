# elasticsearch-ruby

An elastic search ruby library with multiple transport support originally built
for use with [SoundTracking](http://www.soundtracking.com/).

> DISCLAIMER: Quite a bit more work to be done till production ready, use at your own
> risk! :)

Installation
------------

    $ gem install elasticsearch-ruby

Usage
-----

```ruby

transport = ElasticSearch::HTTPTransport.new(['http://localhost:9200'])
client = ElasticSearch::Client.new(transport)

index = client.create_index('twitter')
index['tweet'].put(1, { foo: 'bar' })

query = { query: { query_string: { query: 'bar' } } }
results = index['tweet'].search(query)

results.total                         # 1
results.explain                       # {"took"=>4, "timed_out"=>false, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0},
                                      #  "hits"=> {"total"=>1, "max_score"=>0.2169777, "hits"=> 
                                      #   [{"_index"=>"twitter", "_type"=>"tweet", "_id"=>"1", "_score"=>0.2169777, "_source"=>{"foo"=>"bar"}}]}}"}

results.each do |result|
  result.score                        # 1.0
  result.explain                      # {"foo"=>"bar"}
  result['foo']                       # bar
end

client['twitter'].search(query).type  # 'tweet'

```

TODO:
-----

* Better configuration support
* Failover and retry code
* Better unicode support with Thrift
* Support for Memcache Transport
* Query Builder and block support
* Stats, Health lookup methods
* Better error handling
* Documentation
