require 'faraday'

module ElasticSearch
  class HTTPTransport < TransportBase
    def execute(request)
      response = current_connection.send(request.method, request.path) do |req|
        req.body = request.body unless request.method.eql?(:delete)
        req.params = request.parameters if request.parameters
      end
      ElasticSearch::Response.new(body: response.body, status: response.status)
    end

    private
    def get_connection(host)
      Faraday.new(:url => host)
    end
  end
end
