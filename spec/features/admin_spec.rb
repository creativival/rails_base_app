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
  end
end
