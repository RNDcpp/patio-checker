require 'sqlite3'
require 'yaml'
module TweetDB
api_key = YAML.load_file("api_key.yml")
client = TwitterOAuth::client.new(
  :consumer_key => api_key['consumer_key'],
  :consumer_secret => api_key['consumer_secret'],
  :api_key => api_key['api_key'],
  :api_secret => api_key['api_secret']
)
  def create(screen_name)
    
  end
  def user_validate(screen_name)
    
  end
end
