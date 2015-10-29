class User < ActiveRecord::Base

  has_many :identities, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :name, presence: true

  ROLE_ADMIN = 'admin'
  ROLE_MODERATOR = 'moderator'
  ROLE_USER = 'user'

  def admin?
    role == ROLE_ADMIN
  end

  def moderator?
    role == ROLE_MODERATOR
  end

  def user?
    role == ROLE_USER
  end

  scope :teachers, ->{ where role: ROLE_TEACHER }
  scope :students, ->{ where role: ROLE_STUDENT }
  scope :users, ->{ where role: [ROLE_STUDENT, ROLE_TEACHER] }

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
            password: Devise.friendly_token[0,20]
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
