# Book model
class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :author
  has_many :book_copies
  has_many :book_genres, dependent: :delete_all
  has_many :genres, through: :book_genres
  belongs_to :language
  has_many :comments, as: :commentable

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  validates :year, inclusion: 1800..Date.today.year

  has_attached_file :cover,
                    url: '/books/:id/:style/:filename',
                    path: ':rails_root/public/books/:id/:style/:filename',
                    styles: { small: 'x200', large: '500x500>' },
                    default_url: '/books/default/:style/default.png'
  validates_attachment :cover,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  scope :genre, -> (genre) { BookGenre.genre(genre).map(&:book) }

  f = lambda do |genres|
    a = []
    genres.each { |g| a |= self.genre(g) }
    return a
  end
  scope :genres, f

  def first_available_copy
    BookCopy.where(book_id: id, available: true).first
  end

  def readers
    bookcopies = BookCopy.where(book_id: id).map(&:id)
    BookCopyUser.where(book_copy_id: bookcopies).count
  end

  scope :title_like, -> (title) { where('title like ?', (title + '%')) }

  scope :by_author, -> (author) { where(author_id: Author.find_by_name(author).map(&:id)) }

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new('books')
    author = Author.find(author_id)
    loader.add('term' => title,
               'id' => id,
               'data' => { 'link' => Rails.application.routes.url_helpers.book_path(self),
                           'author' => author.first_name + ' ' + author.last_name })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new('books')
    loader.remove('id' => id)
  end
end
