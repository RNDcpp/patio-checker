class User < ActiveRecord::Base
  has_many :word_counts
  has_many :tweets
end
