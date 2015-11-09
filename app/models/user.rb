# User model
class User < ActiveRecord::Base
  has_many :identities, dependent: :destroy
  has_many :books

  has_many :book_copies
  has_many :book_copy_users

  has_many :comments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :name, presence: true

  has_attached_file :avatar,
                    styles: { medium: '300x300>',
                              thumb: '100x100>',
                              default_url: '/default/missing.png' }
  validates_attachment :avatar,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
                       size: { in: 0..1000.kilobytes }

  ROLE_ADMIN = 'admin'
  ROLE_MODERATOR = 'moderator'
  ROLE_USER = 'user'

  def moderator?
    role == ROLE_MODERATOR
  end

  def user?
    role == ROLE_USER
  end

  def is_debtor?
    bc = BookCopyUser.where(user_id: id, return_date: nil)
    bc.each do |b|
      return true if must_return_book? b.book_copy.book
    end
    return false
  end

  def have_book?(book)
    @book = book
    @copies = @book.book_copies
    @copies.each do |c|
      unless c.available
        myc = c.book_copy_users.where(user_id: id, return_date: nil).last
        return myc if myc
      end
    end
    return nil
  end

  def must_return_book?(book)
    have_book?(book).last_date < Date.today
  end

  scope :moderators, -> { where role: ROLE_MODERATOR }
  scope :users, -> { where role: ROLE_USER }

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    if identity
      user = identity.user
    else
      user = User.where(email: auth.info.email).first
      if user.nil?
        user = User.new(name: auth.extra.raw_info[:name],
                        email: auth.extra.raw_info[:email],
                        password: Devise.friendly_token[0, 20],
                        role: 'user')
        user.save!
      end
      identity = Identity.new(provider: auth.provider,
                              uid: auth.uid,
                              user_id: user.id)
      identity.save!
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
end
