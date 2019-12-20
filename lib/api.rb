require 'pry-byebug'
require 'faraday'
require 'addressable/uri'
require 'simple_oauth'
require 'awesome_print'
require 'time'

class API_Call

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

  def get_token(username)
    url = "https://api.twitter.com/oauth/request_token"
  end

  def get_auth(url, verb, token = nil)
    credentials = {
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      token: "931324288757575682-xpWB8tTkZORzk1jpRtlWzWPMKGLHHMc",
      token_secret: "aSkHcFLeXPE78iX64qqRrcXmVjRjqhuIvqFaAVqTMGn04"
    }
    options = {}
    auth = SimpleOAuth::Header.new(verb.to_s.upcase, url, options, credentials.merge(ignore_extra_keys: true))
    headers = {}
    headers[:authorization] = auth.to_s
    return headers
  end

  def get_all(type, time, list = [], max_id = nil)
    url = endpoints(type+"_l")
    params = list.empty? ? "?count=200" : "?count=200&max_id=#{max_id}"
    url_params = url + params
    req = Faraday.new(
      url: url,
      params: max_id ? {count: 200, max_id: max_id} : {count: 200},
      headers: get_auth(url_params, 'GET')
      )
    response = JSON.parse(req.get.body)
    list += response
    if response.empty?
      to_delete = list.select { |tweet| Time.parse(tweet["created_at"]) < time }
      id_array = to_delete.map { |r| r["id"]}
      return id_array
    else
      get_all(type, time, list, list.last["id"] - 1)
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
