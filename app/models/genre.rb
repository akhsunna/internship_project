class Genre < ActiveRecord::Base
  has_many :book_genres, dependent: :delete_all
  has_many :books, through: :book_genres




end
