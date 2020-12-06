require Config.app_root_path('lib/mecab_client')

class Tweet < ActiveRecord::Base
  class AlreadyCountedError < StandardError; end
  class UncountedError < StandardError; end
  belongs_to :user
  validates :posted_at, uniqueness: { scope: :user }
  validates :text, format: { with: /\A(?!RT).+\z/ }

  def generate_word_count!
    raise AlreadyCountedError if counted

    ActiveRecord::Base.transaction do
      words.each do |word|
        word_count = word.word_counts.find_or_initialize_by(user: user)
        word_count.inclement!
        word.save!
      end
      counted = true
      save!
    end
  end

  def revert_word_count!
    raise UncountedError unless counted

    ActiveRecord::Base.transaction do
      words.each do |word|
        word_count = word.word_counts.find_by(user: user)
        word_count.declement!
      end

      counted = false
      save!
    end
  end

  def words
    words = []
    MeCabClient.instance.parse(text) { |node| words << Word.find_or_initialize_from(node) }
    words.compact
  end
end
