require 'open-uri'
require 'nokogiri'

module TwilogParser
  class Parser
    def get(screen_name, limit: 1, sleep_sec: 5)
      limit.times do |i|
        html = URI.open("http://twilog.org/#{screen_name}/nort-#{i+1}",'User-Agent'=>'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)') do |f|
          f.read
        end
        doc = Nokogiri::HTML.parse(html,nil,'UTF-8')
        # title01
        dates = doc.xpath('//*[@class = "title01"]')
        tweets = dates.zip(doc.xpath('//*[@class = "tl-tweets"]')).map do |date_dom, tl|
          date = date_dom.xpath('.//a').first.text&.gsub(/(年|月)/,'/')&.gsub(/日\(.\)/,'')
          tl.xpath('.//*[@class = "tl-tweet"]').map do |t|
            text = t.xpath('.//*[@class = "tl-text"]').first&.text
            hms = t.xpath('.//*[@class = "tl-posted"]').first&.text&.gsub('posted at ','')
            date_time = date + ' ' + hms
            Tweet.new(screen_name: screen_name, text: text, posted_at: Time.parse(date_time))
          end
        end.flatten
        binding.irb
        sleep(sleep_sec)
      end
      tweets
    end
  end

  class Tweet
    attr_accessor :screen_name, :text, :posted_at
    def initialize(screen_name:, text:, posted_at:)
      @screen_name
      @text = text
      @posted_at = posted_at
    end
  end
end