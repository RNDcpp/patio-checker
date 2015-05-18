require 'twitter_oauth'
module TwitterLib
$api_key = YAML.load_file("api_key.yml")
$client = TwitterOAuth::client.new(
  :consumer_key => api_key['consumer_key'],
  :consumer_secret => api_key['consumer_secret'],
  :api_key => api_key['api_key'],
  :api_secret => api_key['api_secret']
)
  def get_tweets(id,)
     
  end
  def get_user_id(name)
    id = nil
    user=client.show(name)
    id = user.id if user
  end 
end
