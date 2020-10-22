require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create :user }

  it 'email, name, profile を変更できる' do
    user.update(
        email: 'RENAME@example.com',
        name: 'RENAME',
        profile: 'I am a test user.'
        )
    puts user.attributes
    expect(user).to be_valid
  end

  it "name がないときは無効" do
    user.attributes = {
        name: '',
    }
    user.save
    expect(user.errors.full_messages[0]).to eq("名前を入力してください")
  end

  it "email がないときは無効" do
    user.attributes = {
        email: '',
    }
    user.save
    expect(user.errors.full_messages[0]).to eq("Eメールを入力してください")
  end

  it "profile が長すぎるときは無効" do
    user.attributes = {
        profile: 'a' * 241,
    }
    user.save
    expect(user.errors.full_messages[0]).to eq("プロフィールは240文字以内で入力してください")
  end
end
