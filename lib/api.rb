require 'pry-byebug'
require 'faraday'
require 'addressable/uri'
require 'simple_oauth'
require 'awesome_print'
require 'time'
require 'launchy'

class API_Call
  def api_keys
    # Get your own keys by registering a developer account on Twitter
    return {
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      callback: "oob" # This is to authenticate via a PIN
    }
  end

  def endpoints(type, id = nil)
    url = "https://api.twitter.com/1.1/"
    hash = {
      tweets_l: "statuses/user_timeline.json",
      tweets_d: "statuses/destroy/#{id}.json",
      likes_l: "favorites/list.json",
      likes_d: "favorites/destroy.json?id=#{id}",
      dm_list: "direct_messages/events/list.json",
      dm_destroy: "direct_messages/events/destroy.json?id=#{id}"
    }
    return url + hash[type.to_sym]
  end

  def oauth_endpoints(type)
    hash = {
      request_token: "https://api.twitter.com/oauth/request_token",
      authorize: "https://api.twitter.com/oauth/authorize?",
      access_token: "https://api.twitter.com/oauth/access_token"
    }
    return hash[type.to_sym]
  end

  def login
    request_token = get_request_token
    authenticate(request_token[0])
    puts "Please input your PIN"
    pin = gets.chomp
    full_tokens = get_access_token(request_token[0].split("=")[1], pin)
    user = { id: full_tokens["user_id"], screen_name: full_tokens["screen_name"] }
    actok = { token: full_tokens["oauth_token"], token_secret: full_tokens["oauth_token_secret"] }
    return [user, actok]
  end

  def get_request_token
    options = {}
    url = oauth_endpoints("request_token")
    auth = SimpleOAuth::Header.new('POST', url, options, api_keys)
    headers = {}
    headers[:authorization] = auth.to_s
    req = Faraday.new(
      url: url,
      headers: headers
      )
    response = req.post.body.split('&')
    return response
  end


  def authenticate(token)
    url = oauth_endpoints("authorize")
    Launchy.open(url+token)
  end

  def get_access_token(reqtok, pin)
    url = oauth_endpoints("access_token")
    req = Faraday.new(
      url: url,
      params: {"oauth_token": reqtok, "oauth_verifier": pin }
      )
    response = req.post.body.split("&")
    params = {}
    response.each do |param|
      params[param.split("=")[0]] = param.split("=")[1]
    end
    return params
  end

  def get_auth(url, verb, actok, token = nil)
    credentials = api_keys.merge(actok)
    options = {}
    auth = SimpleOAuth::Header.new(verb.to_s.upcase, url, options, credentials.merge(ignore_extra_keys: true))
    headers = {}
    headers[:authorization] = auth.to_s
    binding.pry
    return headers
  end

  def collect(type, time, actok, list = [], max_id = nil)
    url = endpoints(type+"_l")
    params = list.empty? ? "?count=200" : "?count=200&max_id=#{max_id}"
    url_params = url + params
    req = Faraday.new(
      url: url,
      params: max_id ? { count: 200, max_id: max_id } : { count: 200 },
      headers: get_auth(url_params, 'GET', actok)
      )
    response = JSON.parse(req.get.body)
    list += response
    if response.empty?
      to_delete = list.select { |tweet| Time.parse(tweet["created_at"]) < time }
      id_array = to_delete.map { |r| r["id"] }
      return id_array
    else
      collect(type, time, list, list.last["id"] - 1)
    end
  end

  def get_dms(timestamp, list = [], cursor = nil)
    url = endpoints('dm_list') + "?count=50"
    url += "&cursor=#{cursor}" if cursor
    req = Faraday.new(
      url: url,
      headers: get_auth(url, 'GET')
      )
    response = JSON.parse(req.get.body)
    if response["errors"]
      puts "Something went wrong with the API, please try again later."
      return "error"
    else
      list += response["events"]
      if !response["next_cursor"]
        to_delete = list.select { |dm| dm['created_timestamp'].to_i < timestamp }
        id_array = to_delete.map { |dm| dm["id"].to_i }
        binding.pry
        return id_array
      else
        get_dms(timestamp, list, response["next_cursor"])
      end
    end
  end

  def delete(type, list)
    list.each_with_index do |id, i|
      url = endpoints(type+"_d", id)
      req = Faraday.new(
        url: url,
        headers: get_auth(url, 'POST')
        )
      response = req.post
      puts "deleted item #{i + 1}"
    end
  end

  def delete_dms(list)
    list.each_with_index do |id, i|
      url = endpoints("dm_destroy")
      req = Faraday.new(
        url: url,
        headers: get_auth(url, 'POST')
        )
      response = req.post
      puts "deleted Direct Message #{i + 1}"
    end
  end
end
