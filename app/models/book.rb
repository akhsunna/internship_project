class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :author

  # has_many :ganre_books, dependent: :delete_all
  # has_many :ganres, through: :ganre_books

  belongs_to :language

end
