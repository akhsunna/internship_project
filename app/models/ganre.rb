class Ganre < ActiveRecord::Base

  has_many :book_ganres, dependent: :delete_all
  has_many :books, through: :book_ganres

end
