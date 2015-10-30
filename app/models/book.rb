class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :author

  # has_many :ganre_books, dependent: :delete_all
  # has_many :ganres, through: :ganre_books

  belongs_to :language

  validates :year, inclusion: 1800..Date.today.year

  has_attached_file :cover, url: '/books/:id/:style/:filename',
                    path: ':rails_root/public/books/:id/:style/:filename',
                    styles: { small: 'x200', large: '500x500>', square: '200x200#' },
                    default_url: '/books/default/:style/default.png'
  validates_attachment :cover,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

end
