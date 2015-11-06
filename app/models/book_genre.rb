class BookGenre < ActiveRecord::Base
  belongs_to :genre
  belongs_to :book



  scope :book, -> (book){ where book_id: book.id }
  scope :genre, -> (genre){ where genre_id: genre.id }



end
