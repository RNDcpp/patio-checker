require 'open-uri'
require 'nokogiri'
require 'csv'

module TwilogParser
  class Parser
    def get_user_list(limit: 10, offset: 0)
      (offset...(offset + limit)).map do |i|
        begin
          puts i
          sleep(10)
          html = URI.open("http://twilog.org/user-list/#{i+1}",'User-Agent'=>'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)') do |f|
            f.read
          end
          doc = Nokogiri::HTML.parse(html,nil,'UTF-8')
          screen_names = doc.xpath('.//*[@class = "section-box01"]//ul//li/descendant::span[2]').map do |span|
            span.text&.gsub('@', '')
          end
        rescue => e
          puts 'Error Occured'
          puts e.message
          sleep(20)
          continue
        end
      end.flatten.compact
    end

    def get(screen_name, limit: 100, sleep_sec: 10, offset: 0)
      total_tweets = []
      prev_id = nil
      (offset...(offset + limit)).each do |i|
        sleep(sleep_sec)
        begin
          html = URI.open("http://twilog.org/#{screen_name}/nort-#{i+1}",'User-Agent'=>'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)') do |f|
            f.read
          end
        rescue => e
          puts 'Error Occured'
          puts e.message
          sleep(20)
          continue
        end
        puts "#{screen_name} #{i+1}"
        doc = Nokogiri::HTML.parse(html,nil,'UTF-8')
        # title01
        attributes = doc.xpath('.//*[@class = "tl-tweet"]')&.first&.attributes
        id = attributes && attributes['id']&.value
        break unless id
        break if prev_id == id
        prev_id = id
        dates = doc.xpath('//*[@class = "title01"]')
        tweets = dates.zip(doc.xpath('//*[@class = "tl-tweets"]')).map do |date_dom, tl|
          date = date_dom.xpath('.//a')&.first&.text&.gsub(/(年|月)/,'/')&.gsub(/日\(.\)/,'')
          tl.xpath('.//*[@class = "tl-tweet"]').map do |t|
            text = t.xpath('.//*[@class = "tl-text"]').first&.text
            hms = t.xpath('.//*[@class = "tl-posted"]').first&.text&.gsub('posted at ','')
            break unless text && hms
            date_time = date + ' ' + hms + ' +0900'
            Tweet.new(screen_name: screen_name, text: text, posted_at: Time.parse(date_time))
          end
        end.flatten
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
