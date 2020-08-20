class Tweet < ApplicationRecord
  validates :content, presence: true 

  belongs_to :user
  has_many :likes
  has_many :liking_users, :through => :likes, :source => :user

  paginates_per 3

  def is_liked?(user)
    if self.liking_users.include?(user)
      true
    else
      false 
    end 
  end 

  def remove_like(user)
    Like.where(user: user, tweet: self).first.destroy
  end

  def add_like(user)
    Like.create(user: user, tweet: self)
  end 


end
