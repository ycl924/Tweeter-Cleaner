require 'pry-byebug'
require 'Faraday'
require 'addressable/uri'
require 'simple_oauth'
require 'ap'
puts "starting"


def set_time
# Set this for the tweets you _don't_ want deleted
  one_week_ago = (Time.now - 60 * 60 * 24 * 7)
  one_month_ago = (Time.now - 60 * 60 * 24 * 31)
  three_months_ago = (Time.now - 60 * 60 * 24 * 31 * 3)
  six_months_ago = (Time.now - 60 * 60 * 24 * 31 * 6)
  one_year_ago = (Time.now - 60 * 60 * 24 * 31 * 12)
  two_years_ago = (Time.now - 60 * 60 * 24 * 31 * 12 * 2)
  puts 'Please select a time frame'
  puts "1.- One week ago"
  puts "2.- One month ago"
  puts "3.- Three months ago"
  puts "4.- Six months ago"
  puts "5.- One year ago"
  puts "6.- Two years ago"
  time_choice = gets.chomp.to_i
  case time_choice
  when 1 then older_than = one_week_ago
  when 2 then older_than = one_month_ago
  when 3 then older_than = three_months_ago
  when 4 then older_than = six_months_ago
  when 5 then older_than = one_year_ago
  when 6 then  older_than = two_years_ago
  end
  return older_than
end

#OAuth stuff
def get_auth(url, verb)
  credentials = {
    consumer_key: "Xv7kLpbKvHDgLFRQBMVhHNehb",
    consumer_secret: "xON3gf3wnYI6u3M7vm4PmoFTK2OBDg7RJQ1rfwc29PZa0ejHTD",
    token: "931324288757575682-xpWB8tTkZORzk1jpRtlWzWPMKGLHHMc",
    token_secret: "aSkHcFLeXPE78iX64qqRrcXmVjRjqhuIvqFaAVqTMGn04"
  }
  options = {}
  auth = SimpleOAuth::Header.new(verb, url, options, credentials.merge(ignore_extra_keys: true))
  headers = {}
  headers[:authorization] = auth.to_s
  return headers
end
# API Call - GET TWEETS

# GET MORE TWEETS

def endpoints(id)
  hash = {
    tweet_list: "https://api.twitter.com/1.1/statuses/user_timeline.json",
    tweet_destroy: "https://api.twitter.com/1.1/statuses/destroy/#{id}.json",
    like_list: "https://api.twitter.com/1.1/favorites/list.json",
    like_destroy: "https://api.twitter.com/1.1/favorites/destroy.json?id=#{id}",
    dm_list: "https://api.twitter.com/1.1/direct_messages/events/list.json",
    dm_destroy: "https://api.twitter.com/1.1/direct_messages/events/destroy.json?id=#{id}"
  }
end

def get_all(url, collection = [], max_id = nil)
  params = collection.empty? ? "?count=200" : "?count=200&max_id=#{max_id}"
  url_params = url+params
  req = Faraday.new(
    url: url,
    params: max_id ? {count: 200, max_id: max_id} : {count: 200},
    headers: get_auth(url_params))
  response = JSON.parse(req.get.body)
  response_ids = response.collect { |r| r["id"]}
  collection += response_ids
  response_ids.empty? ? collection.flatten : get_all_tweets(collection, (collection[-1] -1))
  return collection
end

def delete

def run
  running = true
  # Set your username here
  puts 'Please input your username'
  twitter_username = gets.chomp  while running
  action = ask_action
end



puts "logging in"
#
#
#
# Once the above has been set, run this script with `ruby /path/to/file`
#
#
#
# --------------------------------------------- #
# Create large array to override max count limits on Twitter API


# Collect all tweets from a user
def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {count: 200, include_rts: true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end
end
# Collect all likes from a user
def client.get_all_likes(user)
  collect_with_max_id do |max_id|
    options = {count:100}
    options[:max_id] = max_id unless max_id.nil?
    favorites(user, options)
  end
end



# FUCKING DIRECT MESSAGES. API is deprecated so have to do it manually here
# LIST
dm_list_url = "https://api.twitter.com/1.1/direct_messages/events/list.json"
options = {count: 50}
request = Twitter::REST::Request.new(client, :get, dm_list_url, options)
def client.get_all_dms(user)
  collect_with_max_id do |max_id|
    options = {count: 50}
    options[:max_id] = max_id unless max_id.nil?
    direct_messages(user, options)
  end
end
# DELETE
def delete_dms
  dm_id = "1206977334189932548"
  delete_dm_url = "https://api.twitter.com/1.1/direct_messages/events/destroy.json?id=#{dm_id}"
  delete_request = Twitter::REST::Request.new(client, :delete, delete_dm_url)
end

def client.delete_tweets(user, time)
  all_tweets = get_all_tweets(user)
  puts "You have a total of #{all_tweets.size} tweets"
  tweets_to_delete = all_tweets.select do |tweet|
    tweet.created_at < time
  end
  puts "We are about to delete #{tweets_to_delete.size} tweets"
  puts "start destroy_status"
  destroy_status(tweets_to_delete)
  puts "end destroy_status"
end

def client.delete_likes(user)
  puts "Getting your likes"
  laiks = get_all_likes(user)
  unfavorite(laiks)
  puts "Likes deleted"
end

def client.list_stuff(user)
  puts "What do you want to do?"
  puts "1. Get all tweets"
  puts "2. Get all likes"
  puts "3. Get all DMs"
  puts "4. Quit"
  user_choice = gets.chomp.to_i
  case user_choice
  when 1
    tweets = get_all_tweets(user)
    puts "You have a total of #{tweets.size} tweets"
  when 2
    laiks = get_all_likes(user)
    puts "You have a total of #{laiks.size} likes"
  when 3
    dms = get_all_dms(user)
    puts "You have a total of #{dms.size} dms"
  end
end
client.list_stuff(twitter_username)
























## Let's see if I can figure this out ##

def pmap(enumerable)
  return to_enum(:pmap, enumerable) unless block_given?
  if enumerable.count == 1
    enumerable.collect { |object| yield(object) }
  else
    enumerable.collect { |object| Thread.new { yield(object) } }.collect(&:value)
  end
end

def direct_messages(*args)
  arguments = Twitter::Arguments.new(args)
  if arguments.empty?
    direct_messages_received(arguments.options)
  else
    pmap(arguments) do |id|
      direct_message(id, arguments.options)
    end
  end
end

 def direct_message(id, options = {})
   direct_message_event(id, options).direct_message
 end

 def direct_message_event(id, options = {})
   options = options.dup
   options[:id] = id
   perform_get_with_object('/1.1/direct_messages/events/show.json', options, Twitter::DirectMessageEvent)
 end

 def perform_request(request_method, path, options = {})
   Twitter::REST::Request.new(self, request_method, path, options).perform
 end
 def perform_request_with_object(request_method, path, options, klass)
   response = perform_request(request_method, path, options)
   klass.new(response)
 end

  def perform_get_with_object(path, options, klass)
    perform_request_with_object(:get, path, options, klass)
  end
