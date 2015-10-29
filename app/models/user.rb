class User < ActiveRecord::Base

  has_many :identities, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :name, presence: true

  def self.find_for_oauth(auth, signed_in_resource = nil)

    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    # user = signed_in_resource ? signed_in_resource : nil

    if identity
      user = identity.user
    else
      user = User.where(email: auth.info.email).first

      # Create the user if it's a new registration
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

    # Associate the identity with the user if needed
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
