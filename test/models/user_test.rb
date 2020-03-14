require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  # ユーザー情報は有効？
  test "should be valid" do
    assert @user.valid?
  end
  
  # 名前が空欄だと有効ではない？
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  # メールが空欄だと有効ではない？
  test "name should be presenct" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  # 名前が51文字だと有効ではない？
  test "name should not be too long" do
    @user.name ="a" * 51
    assert_not @user.valid?
  end
  
  # メールが244文字だと有効ではない？
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # 無効なメールアドレスを検証する
  test "email validation should reject invalid addressess" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # 重複するメールアドレスは有効ではない？
   test "email addresses should be unique" do
     duplicate_user = @user.dup
     duplicate_user.email = @user.email.upcase
     @user.save
     assert_not duplicate_user.valid?
   end
   
  # メールアドレスを小文字に変換して保存する
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # パスワードが空白だと有効ではない？
  test "password should be present (noblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  # パスワードが5文字だと有効ではない？
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end