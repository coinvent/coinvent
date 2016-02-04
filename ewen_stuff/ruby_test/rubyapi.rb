require 'rest-client'
require 'json'


def execute_request()
    # a = {\
    #   method:    :post,
    #   url:       "localhost:8300/cmd/hdtp",
    #   request:   "start",
    #  #wget:      "yes",
    #   input1:    ARGV[0], # the URL of the first input space
    #   input2:    ARGV[1]  # the URL of the second input space
    # }

 post_params = {action: 'hets', input1: {url: ARGV[0]}.to_json, input2: {url: ARGV[1]}.to_json}
  response = RestClient::Request.execute({method: :post,url:
"148.251.85.37:8300/cmd/blend",payload: post_params})
    return response
end

x = execute_request()

my_hash = JSON.parse(x)

my_hash.each do |k,v|
  puts k + ':' + v.to_s
end

