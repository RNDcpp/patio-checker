class WordCount < ActiveRecord::Base
  belongs_to :word
  belongs_to :user

  def inclement!
    self.count += 1
    save!
  end

  def declement!
    self.count -= 1
    save!
  end
end
