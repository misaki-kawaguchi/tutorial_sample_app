class User < ApplicationRecord
  attr_accessor :remember_token
  # 保存する前にメールアドレスを小文字に変換する
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  # 名前は最大50文字、空白はエラー
  validates :name, presence: true, length: {maximum: 50} 
  # メールフォーマットを正規表現で検証
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # メールアドレスは最大255文字、空白はエラー、正規表現で検証、大文字小文字の差を無視する
  validates :email, presence: true, length: {maximum: 255},
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  # パスワードをハッシュ化して保存する
  has_secure_password
  # パスワードは最小6文字、空白はエラー
  validates :password, presence: true, length: {minimum: 6 }
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    # ログインしたらnew_token（ランダムな文字）を発行し、remember_token（自分を呼び出したインスタンスメソッド）に代入する
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
