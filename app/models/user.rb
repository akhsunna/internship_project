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


  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>', default_url: '/default/missing.png' }
  validates_attachment :avatar,
                       content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
                       size: { in: 0..1000.kilobytes }

  ROLE_ADMIN = 'admin'
  ROLE_MODERATOR = 'moderator'
  ROLE_USER = 'user'

  # def admin?
  #   role == ROLE_ADMIN
  # end

  def moderator?
    role == ROLE_MODERATOR
  end

  def user?
    role == ROLE_USER
  end

  def is_debtor?
    !BookCopyUser.where(user_id: id, return_date: nil).empty?
  end

  def have_book?(book)
    @book = book
    @copies = @book.book_copies
    @copies.each do |c|
      if !c.available
        myc = c.book_copy_users.where(user_id: id, return_date: nil).last
        if myc
          return myc
        end
      end
    end
    return nil
  end

  def must_return_book?(book)
    have_book?(book).last_date < Date.today
  end

  scope :moderators, ->{ where role: ROLE_MODERATOR }
  scope :users, ->{ where role: ROLE_USER }

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    if identity
      user = identity.user
    else
      user = User.where(email: auth.info.email).first
      if user.nil?
        user = User.new(
            name: auth.extra.raw_info[:name],
            email: auth.extra.raw_info[:email] ,
            password: Devise.friendly_token[0,20],
            role: 'user'
        )
        user.save!
      end
      identity = Identity.new(
          provider: auth.provider,
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


  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #   end
  # end


end
