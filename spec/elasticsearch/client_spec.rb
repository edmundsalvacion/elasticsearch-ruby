require 'spec_helper'

describe ElasticSearch::Client do
  TRANSPORT_CONTEXTS.each do |transport, context|
    describe context do
      let :client do
        ElasticSearch::Client.new(transport)
      end

      after do
        begin
          client.delete_index(TEST_INDEX)
        rescue
        end
      end

      describe :create_index do
        it "should create a new index" do
          index = client.create_index(TEST_INDEX)
          index.must_be_instance_of ElasticSearch::Index
          index.refresh
          client.has_index?(TEST_INDEX).must_equal true
        end

        it "should create a new index with a mapping" do
          mapping = {
            test_type: {
              properties: {
                foo: { type: :string, analyzer: :keyword }
              }
            }
          }
          index = client.create_index(TEST_INDEX, mappings: mapping)
          index.mapping['test_index']['test_type']['properties']['foo']['analyzer'].must_equal "keyword"
          index.mapping['test_index']['test_type']['properties']['foo']['type'].must_equal "string"
        end
      end

      describe :delete_index do
        it "should delete an index" do
          client.has_index?(TEST_INDEX).must_equal false
        end
      end

      describe :has_index? do
        it "should know if an index exists" do
          client.create_index(TEST_INDEX).refresh
          client.has_index?(TEST_INDEX).must_equal true
        end
      end
    end
  end
end
