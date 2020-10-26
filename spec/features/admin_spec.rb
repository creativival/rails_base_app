require 'rails_helper'

RSpec.feature "Admins", type: :feature, js: true do

  (1..11).each do |i|
    user = "user#{ i }"
    let!(user.to_sym) { create user.to_sym }
  end

  context "ログインしていないとき" do
    it 'ログインページを表示する' do
      visit admin_root_path
      expect(page.current_path).to eq new_user_session_path
      expect(page).to have_css('.alert-warning', text: 'アカウント登録もしくはログインしてください。')
    end
  end

  context "管理者以外でログインしているとき" do
    before(:each) do
      login_as user2, scope: :user
    end

    it 'ロートページにリダイレクトする' do
      visit root_path
      expect(page).to have_link 'アカウント'
      expect(page).to have_no_link '管理者ページ'
      visit admin_root_path
      expect(page.current_path).to eq root_path
      expect(page).to have_css('.alert-warning', text: '管理者のみ閲覧可能なページです。詳しくは管理者にお問い合わせください。')
    end
  end

  context "管理者でログインしているとき" do
    before(:each) do
      login_as user1, scope: :user
    end

    it '管理画面を表示できる' do
      visit root_path
      within 'header nav.navbar' do
        click_link "管理者ページ"
      end
      sleep 1
      within 'header nav.navbar div.dropdown-menu' do
        click_link '管理画面'
      end
      sleep 1
      expect(page.current_path).to eq admin_root_path
    end

    it '管理画面でユーザーを全員表示できる' do
      visit admin_root_path
      expect(page.current_path).to eq admin_root_path
      page.assert_selector('tr.js-table-row', count: 11)
      expect(page.all('a.action-show', text: 'admin').size).to eq(1)
      expect(page.all('a.action-show', text: 'user').size).to eq(32)
    end

    it '管理画面でユーザーを編集できる' do
      visit admin_root_path
      expect(page.all('a.action-show', text: 'admin').size).to eq(1)
      first('tr.js-table-row').click_link '編集'
      expect(page.current_path).to eq edit_admin_user_path user11
      fill_in '名前', with: 'RENAME'
      fill_in 'メールアドレス', with: 'rename@example.com'
      execute_script('window.scrollBy(0,10000)') # scroll
      select 'admin', from: 'Role'
      click_button '更新する'
      expect(page.current_path).to eq admin_user_path user11
      expect(page).to have_content 'RENAME'
      expect(page).to have_content 'rename@example.com' # unconfirmed_email(登録はされていない)
      expect(page).to have_content 'admin' # unconfirmed_email
    end

    it '管理画面でプロフィール画像を変更できる' do
      file_path = Rails.root.join('spec', 'support', 'assets', 'avatar.png')

      visit edit_admin_user_path user11
      expect(page.current_path).to eq edit_admin_user_path user11
      attach_file('user_avatar', file_path)
      execute_script('window.scrollBy(0,10000)') # scroll
      click_button '更新する'
      expect(page.current_path).to eq admin_user_path user11
      expect(page).to have_css('.flash-notice', text: 'Userを更新しました。')
      expect(page.find('img')['src']).to have_content 'avatar.png'
    end

    it '管理画面からアプリに戻れる' do
      visit admin_root_path
      click_link 'アプリに戻る'
      expect(page.current_path).to eq root_path
    end
  end
end
