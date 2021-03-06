#require './lib/nomlish_api'
#require './lib/bot_logger'
require 'net/http'
require 'uri'
require 'json'
require 'oauth'
require 'yaml'

module TwitterAPI
  TWEET_STREAM = URI.parse('https://stream.twitter.com/1.1/statuses/sample.json?language=ja')
  class User
  attr_accessor :name, :screen_name
    def initialize(json)
      @name = json['name']
      @screen_name = json['screen_name']
    end
  end
  class Status
  attr_accessor :user, :text,:retweet ,:id
    def initialize(json)
      @id = json['id']
      @user = User.new(json['user'])
      @text = json['text']
      @retweet = json['retweeted_status']
    end
    def self.set_filter(&block)
      @@filter_block = block
    end
    def filter
      @@filter_block.call(self)
    end
  end
  class << self
    def init(file_name)
      config_file = YAML.load_file file_name
        @@consumer = OAuth::Consumer.new(
          config_file['consumer_key'],
          config_file['consumer_key_secret'],
          site: 'http://twitter.com'
        )
        @@access_token = OAuth::AccessToken.new(
          @@consumer,
          config_file['oauth_token'],
          config_file['oauth_token_secret']
        )
   #     BotLog.message.debug 'TwitterAPI init'
    end
    def connect_stream
      https = Net::HTTP.new(TWEET_STREAM.host,TWEET_STREAM.port)
      https.use_ssl = true
      https.ca_file = './ca_file/userstream.twitter.com'
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5
      https.start do |https|
        puts 'start https'
        request = Net::HTTP::Get.new(TWEET_STREAM.request_uri)
        request['User-Agent'] = 'Nomurish Patio Bot'
        request['Accept-Encoding']='identity'
        begin 
          request.oauth!(https,@@consumer,@@access_token)
        rescue => e
          puts e.message
          raise e
        end
        buf = ''
        https.request(request)do |response|
          puts response
          raise "Response is not Chunked \n #{response.read_body}" unless response.chunked?
          response.read_body do |chunk|
            puts'response chunk'
            buf << chunk
            while(line = buf[/.+?(\r\n)+/m]) != nil
              begin
                buf.sub!(line,"")
                line.strip!
                yield(Status.new(JSON.parse(line))) #rescue next
              rescue=>e
                puts e.message
              end
            end
          end
        end
      end
    end
    def find_by_user_name(user_name)
      @@client.user(user_name)
    end
    def update(text,id)
      response = @@access_token.post('https://api.twitter.com/1.1/statuses/update.json',{'status'=>text,'in_reply_to_status_id'=>id})
      Status.new(JSON.parse(response.body)) rescue response
    end
  end
end
