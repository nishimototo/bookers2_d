class Book < ApplicationRecord
  is_impressionable

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200}
  validates :rate, presence: true, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }


  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(word, search)
    if search == "perfect_match"
      Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      Book.where("title LIKE?", "#{word}%")
    elsif search == "backword_match"
      Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      Book.where("title LIKE?", "%#{word}%")
    else
      Book.all
    end
  end

  def self.book_search(keyword)
    Book.where("category LIKE?", "%#{keyword}%")
  end
end
