require 'rails_helper'

feature 'User', type: :feature, js: true do

  %w(user1 user2 user3).each do |user|
    let!(user.to_sym) { create user.to_sym }
  end

  context "ログインしていないとき" do
    it 'アカウント登録できる' do
      sign_up_email = 'sign-up@example.com'
      visit root_path
      within 'header nav.navbar' do
        click_link 'アカウント登録'
      end
      fill_in '名前', with: 'sign-up'
      fill_in 'メールアドレス', with: sign_up_email
      fill_in 'パスワード（6字以上）', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_button 'カウント登録'
      expect(page).to have_css('.alert-info', text: '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。')
      email = ActionMailer::Base.deliveries.last
      # puts email
      expect(email.subject.toutf8).to eq 'メールアドレス確認メール'
      expect(email.to[0]).to eq sign_up_email
      expect(email.body.raw_source.toutf8).to match /以下のリンクをクリックし、メールアドレスの確認手続を完了させてください。/
      body = email.body.raw_source.toutf8
      confirmation_link = body.match(/href="(.+?)"/)
      visit confirmation_link[1].sub('3000', '3001') # Because Capybara.server_port = "3001"
      expect(page.current_path).to eq(new_user_session_path)
      expect(page).to have_css('.alert-info', text: 'メールアドレスが確認できました。')
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: 'password'
      within 'div.actions' do
        click_button 'ログイン'
      end
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'ログインしました。')
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
      sign_up_email = 'sign-up@example.com'

      visit root_path
      within 'header nav.navbar' do
        click_link 'アカウント登録'
      end
      fill_in 'メールアドレス', with: sign_up_email
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
      fill_in 'メールアドレス', with: sign_up_email
      click_button 'アカウント確認メール再送'
      expect(page.current_path).to eq('/users/sign_in')
      expect(page).to have_css('.alert-info', text: 'アカウントの有効化について数分以内にメールでご連絡します。')
      email = ActionMailer::Base.deliveries.last
      # puts email
      expect(email.subject.toutf8).to eq 'メールアドレス確認メール'
      expect(email.to[0]).to eq sign_up_email
      expect(email.body.raw_source.toutf8).to match /以下のリンクをクリックし、メールアドレスの確認手続を完了させてください。/
      body = email.body.raw_source.toutf8
      confirmation_link = body.match(/href="(.+?)"/)
      visit confirmation_link[1].sub('3000', '3001') # Because Capybara.server_port = "3001"
      expect(page.current_path).to eq(new_user_session_path)
      expect(page).to have_css('.alert-info', text: 'メールアドレスが確認できました。')
      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: 'password'
      within 'div.actions' do
        click_button 'ログイン'
      end
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'ログインしました。')
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

    it 'パスワードを再設定できる' do
      new_password = 'new_password'

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
      body = email.body.raw_source.toutf8
      edit_password_link = body.match(/href="(.+?)"/)
      visit edit_password_link[1].sub('3000', '3001') # Because Capybara.server_port = "3001"
      expect(page.current_path).to eq(edit_user_password_path)
      fill_in '新しいパスワード（6字以上）', with: new_password
      fill_in '確認用新しいパスワード', with: new_password
      click_button 'パスワードを変更する'
      expect(page.current_path).to eq(root_path)
      expect(page).to have_css('.alert-info', text: 'パスワードが正しく変更されました。')
      # パスワードが変更されているか確認
      sleep(1)
      within 'header nav.navbar' do
        click_link "アカウント"
      end
      sleep(1)
      within 'header nav.navbar div.dropdown-menu' do
        click_link 'アカウント情報の編集'
      end
      sleep(1)
      expect(page.current_path).to eq(edit_user_registration_path)
      fill_in '現在のパスワード', with: new_password
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
    end

    it 'アカウント情報ページを表示できない' do
      visit user_path(user1)
      expect(page.current_path).to eq(new_user_session_path)
      expect(page).to have_css('.alert-warning', text: 'アカウント登録もしくはログインしてください。')
    end
  end

  context "ログインしているとき" do
    before(:each) do
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

    it '名前を変更できる' do
      visit root_path
      within 'header nav.navbar' do
        click_link "アカウント"
      end
      sleep(1)
      within 'header nav.navbar div.dropdown-menu' do
        click_link 'アカウント情報の編集'
      end
      sleep(1)
      expect(page.current_path).to eq(edit_user_registration_path)
      fill_in '名前', with: 'RENAME'
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
      expect(page).to have_text '名前: RENAME'
    end

    it 'メールアドレスを変更できる' do
      old_email = user1.email
      new_email = 'rename@example.com'

      visit edit_user_registration_path user1
      expect(page.current_path).to eq(edit_user_registration_path user1)
      fill_in 'メールアドレス', with: new_email
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。')
      expect(page).to have_text "メールアドレス: #{ old_email }" # まだ変更されていない
      email = ActionMailer::Base.deliveries.last
      expect(email.subject.toutf8).to eq 'メールアドレス確認メール'
      expect(email.to[0]).to eq new_email
      expect(email.body.raw_source.toutf8).to match /以下のリンクをクリックし、メールアドレスの確認手続を完了させてください。/
      body = email.body.raw_source.toutf8
      confirmation_link = body.match(/href="(.+?)"/)
      visit confirmation_link[1].sub('3000', '3001') # Because Capybara.server_port = "3001"
      expect(page.current_path).to eq(new_user_session_path)
      expect(page).to have_css('.alert-info', text: 'メールアドレスが確認できました。')
      fill_in 'メールアドレス', with: new_email
      fill_in 'パスワード', with: 'password'
      within 'div.actions' do
        click_button 'ログイン'
      end
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'ログインしました。')
      expect(page).to have_text "メールアドレス: #{ new_email }" # 変更された
    end

    it 'プロフィールを変更できる' do
      visit edit_user_registration_path user1
      expect(page.current_path).to eq(edit_user_registration_path user1)
      fill_in 'プロフィール', with: 'こんにちは！'
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
      expect(page).to have_text 'プロフィール: こんにちは！'
    end

    it 'パスワードを変更できる' do
      new_password = 'new_password'

      visit edit_user_registration_path user1
      expect(page.current_path).to eq(edit_user_registration_path user1)
      fill_in '新しいパスワード', with: new_password
      fill_in 'パスワード（確認用）', with: new_password
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
      # パスワードが変更されているか確認
      sleep(1)
      within 'header nav.navbar' do
        click_link "アカウント"
      end
      sleep(1)
      within 'header nav.navbar div.dropdown-menu' do
        click_link 'アカウント情報の編集'
      end
      sleep(1)
      expect(page.current_path).to eq(edit_user_registration_path)
      fill_in '現在のパスワード', with: new_password
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
    end

    it 'プロフィール画像を変更できる' do
      file_path = Rails.root.join('spec', 'support', 'assets', 'avatar.png')

      visit edit_user_registration_path user1
      expect(page.current_path).to eq(edit_user_registration_path user1)
      attach_file('user_avatar', file_path, make_visible: true) # input要素が opacity: 0
      fill_in '現在のパスワード', with: 'password'
      click_button '更新'
      expect(page.current_path).to eq(user_path user1)
      expect(page).to have_css('.alert-info', text: 'アカウント情報を変更しました。')
      expect(page.find('.user_avatar')['src']).to have_content 'avatar.png'
    end
  end
end