class User < ApplicationRecord
  has_many :microposts, dependent: :destroy # いっぱい持ってる destroyできるで
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: true
                    uniqueness: { case_sensitive: false } # 大文字小文字の区別なし

  validates :password, length: { minimum: 5 }, allow_nil: true # 編集中に何も入れられなかったら今までのをそのまま

  has_secure_password
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

  # rubyらしいメタプロ
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # userログアウト
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウント有効化
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now) # validationきかないからあんま使わないでね
  end

  # 有効化用のメール送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now # selfだよ
  end

  # パスワード再設定用の属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago # 2時間以内なら
  end

  # 　しさくふぃーど
  def feed
    Micropost.where('user_id = ?', id) # ?でエスケープ
  end

  private

  # mail address to downcase
  def downcase_email
    email.downcase!
  end

  # 有効化トークンとダイジェストを作成および代入
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
