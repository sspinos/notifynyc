require 'yajl'
require 'tweetstream'
require 'twitter'
require 'rubygems'
require 'active_record'
require 'uri'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/dbdevelopment')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

#ActiveRecord::Base.establish_connection(
#  :adapter=>"postgresql",
#  :database => "db/development",
#  :host=>"localhost",
#  :username => "postgres",
#  :password => "root",
#)

class Authorization < ActiveRecord::Base
end
class User < ActiveRecord::Base
end

authorizations = Authorization.where(:provider =>"twitter")

TWITTER_KEY = 'tm22skFBlwk9wPZDSwQdA'
TWITTER_SECRET = 'uFo7qpeiTNECsDPxW0nIgqa4Gt4iC6G0it6AYyvamw4'

def authenticate(oauth_token,oauth_secret)
 Twitter.configure do |config|
   config.consumer_key = TWITTER_KEY
   config.consumer_secret = TWITTER_SECRET
   config.oauth_token = oauth_token
   config.oauth_token_secret = oauth_secret
 end
end

def isTweetable (sid,uid,auid)
  #puts "retweet status is :"
  #puts Twitter.status(sid).inspect
  if !sid.nil? && Twitter.status(sid)["in_reply_to_user_id"].nil? && Twitter.status(sid)["retweeted_status"].nil? && uid.to_s != auid.to_s
   #puts "true"
   return true
  end
   #puts "false"
  return false
end

TweetStream.configure do |config|
  config.consumer_key = TWITTER_KEY
  config.consumer_secret = TWITTER_SECRET
  config.oauth_token = "526833838-uU3CS951QoSf29p6M3Gkq6NgwekrTgtysTKo9sJ5"
  config.oauth_token_secret = "o2NXLtXV2isORqeDe9MByBzBC8ZMG1weS5ienih2I"
  #config.auth_method = :oauth
  #config.parser   = :yajl
end

client = TweetStream::Client.new

client.on_error do |message|
  puts message
end


client.follow(237290525,16145875) do |status|
  #puts status.inspect
  authorizations.each do |authorization|
    oauth_token = authorization.token
    oauth_secret = authorization.secret
    auid = authorization.uid.to_i
    #puts "authenticating...#{auid} and #{status.user.id} ...status id is #{status.id}"
    authenticate(oauth_token,oauth_secret)
    if isTweetable(status.id,status.user.id,auid)
	#puts "retweeting..."
	begin
    	 Twitter.retweet(status.id);
	rescue Twitter::Error::Unauthorized #if access is revoked from twitter
	 #puts "You have been deregistered" 
	 user = User.find(authorization.user_id)
	 user.delete
	 authorization.delete
	end
    end
  end
  
  #puts "#{status.text}"
end
