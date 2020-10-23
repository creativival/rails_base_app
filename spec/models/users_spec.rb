require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build :user }

  let!(:user_attached_image) { build(:user, :with_avatar) }

  let!(:user_too_large_avatar) { build(:user, :with_too_large_avatar) }

  let!(:user_attached_not_image) { build(:user, :with_not_image) }

  describe 'Validation' do
    context 'email, name, profile が正しいとき' do
      it 'ユーザー情報を変更できる' do
        user.update(
            email: 'RENAME@example.com',
            name: 'RENAME',
            profile: 'I am a test user.'
        )
        expect(user).to be_valid
      end
    end

    context 'email がないとき' do
      it "エラーメッセージが返る" do
        user.attributes = {
            name: '',
        }
        user.save
        expect(user.errors.full_messages[0]).to eq("名前を入力してください")
      end
    end

    context 'name がないとき' do
      it "エラーメッセージが返る" do
        user.attributes = {
            email: '',
        }
        user.save
        expect(user.errors.full_messages[0]).to eq("メールアドレスを入力してください")
      end
    end

    context 'profile が長すぎるとき' do
      it "エラーメッセージが返る" do
        user.attributes = {
            profile: 'a' * 241,
        }
        user.save
        expect(user.errors.full_messages[0]).to eq("プロフィールは240文字以内で入力してください")
      end
    end

    context "画像ファイルが正しいとき" do
      it "プロフィール画像を添付できる" do
        # user_attached_image.valid?
        # puts user_attached_image.errors.instance_variables
        # puts user_attached_image.errors.messages
        expect(user_attached_image).to be_valid
      end
    end

    context "ファイルサイズが10MBを越える時" do
      it "エラーメッセージが返る" do
        user_too_large_avatar.valid?
        # puts user_too_large_avatar.instance_variables
        # puts user_too_large_avatar.errors.instance_variables
        # puts user_too_large_avatar.errors.messages
        expect(user_too_large_avatar.errors[:avatar]).to include 'ファイルサイズが大きすぎます。'
      end
    end

    context "ファイルの種類がjpeg, jpg, png, gif以外の時" do
      it "エラーメッセージが返る" do
        user_attached_not_image.valid?
        expect(user_attached_not_image.errors[:avatar]).to include 'ファイルが対応している画像データではありません。'
      end
    end

  end

end
