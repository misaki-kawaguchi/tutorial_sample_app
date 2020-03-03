class SessionsController < ApplicationController
  
  # /login
  def new
  end
  
  # /login
  def create
    # 送信されたメールアドレスを使って、データベースからユーザーを取り出す
    user = User.find_by(email: params[:session][:email].downcase)
    # 入力されたメールアドレスを持つユーザーがデータベースに存在し、かつ入力されたパスワードはそのユーザーのパスワードの場合
    if user && user.authenticate(params[:session][:password])
      # ログインする
      log_in user
      # チェックボックスがオンの時に「1」、オフの時に「0」になる
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      redirect_to user
    else
      # エラーメッセージを表示する
      flash.now[:danger] = 'Invalid email/password combination'
      # ログインページに戻る
      render 'new'
    end
  end
  
  # /logout
  def destroy
    # ログアウトする
    log_out if logged_in?
    # トップページに戻る
    redirect_to root_url
  end
end
