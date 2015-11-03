class BookCopy < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  has_many :book_copy_users
end
