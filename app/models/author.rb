# Author model
class Author < ActiveRecord::Base
  has_many :books
  has_many :comments, as: :commentable

  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  def readers
    b = Book.where(author_id: id).map(&:readers)
    b.sum
  end

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new('authors')
    loader.add('term' => last_name, 'id' => self.id, 'data' => {
                                 'link' => Rails.application.routes.url_helpers.author_path(self),
                                 'first_name' => first_name
                             })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new('authors')
    loader.remove('id' => self.id)
  end
end
