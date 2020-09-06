class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friends, dependent: :delete_all        
  has_many :tweets, dependent: :delete_all 
  has_many :likes, dependent: :delete_all 
  has_many :liked_tweets, :through => :likes, :source => :tweet 

  #def admin
  #  self.admin ? true : false
  #end 

  def users_followed
    arr_ids = self.friends.pluck(:friend_id)
    User.find(arr_ids)
  end

  def is_following?(user)
    users_followed.include? (user)
  end

  def friends_count
    #Friend.where(user: self).count
    self.friends.count
  end 
    
  def tweets_count
    #Tweet.where(user_id: self.id).where(rt_ref: nil).count
    self.tweets.where(rt_ref: nil).count
  end 
    
  def likes_give_it
    self.likes.count
  end 
  
  def retweets_give_it
    #Tweet.where(user_id: self.id).where.not(rt_ref: nil).count
    self.tweets.where.not(rt_ref: nil).count
  end 

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

end
