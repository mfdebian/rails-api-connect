require 'net/http'
require 'json'

class UsersService
  BASE_URL = 'https://jsonplaceholder.typicode.com/users'

  def self.call
    url = URI.parse(BASE_URL)
    response = Net::HTTP.get_response(url)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def self.create(user_params)
    url = URI.parse(BASE_URL)
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Post.new(url.path, {'Content-Type' => 'application/json'})
    request.body = user_params.to_json
  
    response = http.request(request)
  
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def self.update(user, user_params)
    # faking the id for the API
    url = URI.parse("#{BASE_URL}/1")
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Put.new(url.path, {'Content-Type' => 'application/json'})
  
    request.body = user_params.to_json
  
    response = http.request(request)
  
    parsed_response = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  
    # returning our user's id
    parsed_response['id'] = user.id
  
    parsed_response
  end

  def self.destroy(id)
    # faking the id for the API
    url = URI.parse("#{BASE_URL}/1")
    http = Net::HTTP.new(url.host)
    request = Net::HTTP::Delete.new(url.path, {'Content-Type' => 'application/json'})
  
    response = http.request(request)
  
    if response.is_a?(Net::HTTPSuccess)
      { status: 200, message: "Deleted user with id #{id}" }
    else
      { status: response.code.to_i, message: "Failed to delete user with id #{id}" }
    end
  end
end
