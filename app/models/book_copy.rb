# Book copy model
class BookCopy < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  has_many :book_copy_users

  validates_uniqueness_of :isbn

  before_create :generate_isbn

  private

  def generate_isbn
    a = (0...3).map { (65 + rand(26)).chr }.join
    b = rand(10**3).to_s.rjust(3)
    c = (0...3).map { (65 + rand(26)).chr }.join
    isbn = [a, b, c].join('-')

    if BookCopy.where(isbn: isbn).first
      generate_isbn
    else
      self.isbn = isbn
    end
  end
end
