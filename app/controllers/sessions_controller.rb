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
      #ユーザーが有効化されている場合
      if user.activated?
        # ログインする
        log_in user
        # チェックボックスがオンの時に「1」、オフの時に「0」になる
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #サインイン成功後にリダイレクトする
        redirect_back_or user
      else
        #有効化されていない場合
        # エラーメッセージを表示する
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        #トップページに戻る
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
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
