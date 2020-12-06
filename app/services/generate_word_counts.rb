module GenerateWordCounts
  COUNT_TWEETS_AFTER = Time.local(2018,01,01)

  class << self
    def generate_word_count
      Tweet.where(counted: false, posted_at: COUNT_TWEETS_AFTER...Time.now).find_in_batches do |tweets|
        begin
          tweets.each(&:generate_word_count!)
        rescue ActiveRecord::RecordInvalid => e
          puts e.message
        end
      end
    end
  end
end
