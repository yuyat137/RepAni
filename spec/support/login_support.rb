module LoginSupport
  def admin_login_as(user, password='password')
    visit admin_login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
