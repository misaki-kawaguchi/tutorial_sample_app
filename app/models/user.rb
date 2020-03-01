class User < ApplicationRecord
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
end
