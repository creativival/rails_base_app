require 'rails_helper'

feature 'User', type: :feature, js: true do

  %w(user1 user2 user3).each do |user|
    let!(user.to_sym) { create user.to_sym }
  end

  context "ログインしていないとき" do
    it 'アカウント登録できる' do
      visit root_path
      within 'header nav.navbar' do
        click_link 'アカウント登録'
      end
      fill_in '名前', with: 'sign-up'
      fill_in 'メールアドレス', with: 'sign-up@example.com'
      fill_in 'パスワード（6字以上）', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_button 'カウント登録'
      expect(page).to have_css('.alert-info', text: '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。')
      email = ActionMailer::Base.deliveries.last
      # puts email
      expect(email.subject.toutf8).to eq 'メールアドレス確認メール'
      expect(email.to[0]).to eq 'sign-up@example.com'
      expect(email.body.raw_source.toutf8).to match /以下のリンクをクリックし、メールアドレスの確認手続を完了させてください。/
    end

    it '同じメールアドレスではアカウント登録できない' do
      visit root_path
      within 'header nav.navbar' do
        click_link 'アカウント登録'
      end
      fill_in 'メールアドレス', with: user1.email
      fill_in '名前', with: user1.name
      fill_in 'パスワード（6字以上）', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_button 'アカウント登録'
      expect(page.current_path).to eq(user_registration_path)
      expect(page).to have_text('エラーが発生したため ユーザ は保存されませんでした。')
      expect(page).to have_text('メールアドレスはすでに存在します')
    end

    it 'アカウント登録メールを再送できる' do
      visit root_path
      within 'header nav.navbar' do
        click_link 'アカウント登録'
      end
      fill_in 'メールアドレス', with: 'sign-up@example.com'
      fill_in '名前', with: 'sign-up'
      fill_in 'パスワード（6字以上）', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_button 'アカウント登録'
      # 仮登録のまま、アカウント確認メールを再送する
      visit root_path
      within 'header nav.navbar' do
        click_link 'ログイン'
      end
      click_link 'アカウント確認のメールを受け取っていません'
      expect(page.current_path).to eq('/users/confirmation/new')
      fill_in 'メールアドレス', with: 'sign-up@example.com'
      click_button 'アカウント確認メール再送'
      expect(page.current_path).to eq('/users/sign_in')
      expect(page).to have_css('.alert-info', text: 'アカウントの有効化について数分以内にメールでご連絡します。')
      email = ActionMailer::Base.deliveries.last
      # puts email
      expect(email.subject.toutf8).to eq 'メールアドレス確認メール'
      expect(email.to[0]).to eq 'sign-up@example.com'
      expect(email.body.raw_source.toutf8).to match /以下のリンクをクリックし、メールアドレスの確認手続を完了させてください。/
    end

    it 'ログインできる' do
      visit root_path
      within 'header nav.navbar' do
        click_link 'ログイン'
      end
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: 'password'
      within 'div.actions' do
        click_button 'ログイン'
      end
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'ログインしました。')
    end

    it 'can forgot_your_password' do
      visit root_path
      within 'header nav.navbar' do
        click_link 'ログイン'
      end
      click_link 'パスワードを忘れましたか?'
      fill_in 'メールアドレス', with: user1.email
      click_button 'パスワードの再設定方法を送信する'
      expect(page.current_path).to eq('/users/sign_in')
      expect(page).to have_css('.alert-info', text: 'パスワードの再設定について数分以内にメールでご連絡いたします。')
      email = ActionMailer::Base.deliveries.last
      expect(email.subject.toutf8).to eq 'パスワードの再設定について'
      expect(email.to[0]).to eq user1.email
      expect(email.body.raw_source.toutf8).to match /パスワード再設定の依頼を受けたため、メールを送信しています。下のリンクからパスワードの再設定ができます。/
    end

    it 'アカウント情報ページを表示できない' do
      visit user_path(user1)
      expect(page.current_path).to eq(new_user_session_path)
      expect(page).to have_css('.alert-warning', text: 'アカウント登録もしくはログインしてください。')
    end
  end

  context "ログインしているとき" do
    before do
      login_as user1, scope: :user
    end

    it 'ログアウトできる' do
      visit root_path
      within 'header nav.navbar' do
        click_link "アカウント"
      end
      sleep(1)
      within 'header nav.navbar div.dropdown-menu' do
        click_link 'ログアウト'
      end
      sleep(1)
      expect(page.current_path).to eq(root_path)
      expect(page).to have_css('.alert-info', text: 'ログアウトしました。')
    end
  end
end