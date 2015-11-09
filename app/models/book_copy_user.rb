# Model for Copies - Users
class BookCopyUser < ActiveRecord::Base
  belongs_to :book_copy
  belongs_to :user
end
