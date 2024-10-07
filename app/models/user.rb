class User < ApplicationRecord
  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: true
                    uniqueness: { case_sensitive: false } # 大文字小文字の区別なし
  has_secure_password
  # validates :password, length: { minimum: 5 }

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続化セッションのためにuserをdbに記憶させる
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # sessionハイジャック防止のためにセッショントークンを返す
  # 　利便性のため
  def session_token
    remember_digest || remember
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil? # remember_tokenじゃないよ

    BCrypt::Password.new(remember_digest).is_password?(remember_token) # remember_tokenはselfのやつ
  end

  # userログアウト
  def forget
    update_attribute(:remember_digest, nil)
  end
end
