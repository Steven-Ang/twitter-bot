class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :nickname, uniqueness: true, presence: true

  has_many :tweets, dependent: :destroy

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end
  
  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.description = auth["info"]["description"]
      user.location = auth["info"]["location"]
      user.image = auth["info"]["image"]
      user.password = SecureRandom.hex(10)
    end
  end

end
