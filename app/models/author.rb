# Author model
class Author < ActiveRecord::Base
  has_many :books
  has_many :comments, as: :commentable

  def readers
    b = Book.where(author_id: id).map(&:readers)
    b.sum
  end
end
