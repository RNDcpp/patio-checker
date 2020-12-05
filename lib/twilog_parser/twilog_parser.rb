require 'open-uri'
require 'nokogiri'
require 'csv'

module TwilogParser
  class Parser
    def get(screen_name, limit: 100, sleep_sec: 2)
      total_tweets = []
      prev_id = nil
      limit.times do |i|
        html = URI.open("http://twilog.org/#{screen_name}/nort-#{i+1}",'User-Agent'=>'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)') do |f|
          f.read
        end
        puts "#{screen_name} #{i+1}"
        doc = Nokogiri::HTML.parse(html,nil,'UTF-8')
        # title01
        id = doc.xpath('.//*[@class = "tl-tweet"]').first.attributes['id'].value
        break if prev_id == id
        prev_id = id
        dates = doc.xpath('//*[@class = "title01"]')
        tweets = dates.zip(doc.xpath('//*[@class = "tl-tweets"]')).map do |date_dom, tl|
          date = date_dom.xpath('.//a').first.text&.gsub(/(年|月)/,'/')&.gsub(/日\(.\)/,'')
          tl.xpath('.//*[@class = "tl-tweet"]').map do |t|
            text = t.xpath('.//*[@class = "tl-text"]').first&.text
            hms = t.xpath('.//*[@class = "tl-posted"]').first&.text&.gsub('posted at ','')
            date_time = date + ' ' + hms + ' +0900'
            Tweet.new(screen_name: screen_name, text: text, posted_at: Time.parse(date_time))
          end
        end.flatten
        sleep(sleep_sec)
        total_tweets += tweets
      end
      TweetsCollection.new(total_tweets)
    end
  end

  class Tweet
    attr_accessor :screen_name, :text, :posted_at
    def initialize(screen_name:, text:, posted_at:)
      @screen_name = screen_name
      @text = text
      @posted_at = posted_at
    end

    def to_csv_row
      [screen_name, text, posted_at]
    end
  end

  class TweetsCollection
    attr_accessor :tweets
    def initialize(tweets)
      @tweets = tweets
    end

    def dump_csv(filename)
      CSV.open(filename, 'wb') do |csv|
        @tweets.each do |tweet|
          csv << tweet.to_csv_row
        end
      end
    end
  end
end
