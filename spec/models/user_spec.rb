require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:model_test) { build :model_test }

  let!(:model_test_attached_image) { build(:model_test, :with_avatar) }

  let!(:model_test_too_large_avatar) { build(:model_test, :with_too_large_avatar) }

  let!(:model_test_attached_not_image) { build(:model_test, :with_not_image) }

  describe 'Validation' do
    context 'email, name, profile が正しいとき' do
      it 'ユーザー情報を変更できる' do
        model_test.update(
            email: 'RENAME@example.com',
            name: 'RENAME',
            profile: 'I am a test model_test.'
        )
        expect(model_test).to be_valid
      end
    end

    context 'email がないとき' do
      it "エラーメッセージが返る" do
        model_test.attributes = {
            name: '',
        }
        model_test.save
        expect(model_test.errors.full_messages[0]).to eq "名前を入力してください"
      end
    end

    context 'name がないとき' do
      it "エラーメッセージが返る" do
        model_test.attributes = {
            email: '',
        }
        model_test.save
        expect(model_test.errors.full_messages[0]).to eq "メールアドレスを入力してください"
      end
    end

    context 'profile が長すぎるとき' do
      it "エラーメッセージが返る" do
        model_test.attributes = {
            profile: 'a' * 241,
        }
        model_test.save
        expect(model_test.errors.full_messages[0]).to eq "プロフィールは240文字以内で入力してください"
      end
    end

    context ':role=>admin のとき' do
      it "管理者に設定できる" do
        expect(model_test.user?).to eq true
        expect(model_test.admin?).to eq false
        model_test.attributes = {
            role: 'admin'
        }
        model_test.save
        expect(model_test.user?).to eq false
        expect(model_test.admin?).to eq true
      end
    end

    context "画像ファイルが正しいとき" do
      it "プロフィール画像を添付できる" do
        # model_test_attached_image.valid?
        # puts model_test_attached_image.errors.instance_variables
        # puts model_test_attached_image.errors.messages
        expect(model_test_attached_image).to be_valid
      end
    end

    context "ファイルサイズが10MBを越える時" do
      it "エラーメッセージが返る" do
        model_test_too_large_avatar.valid?
        # puts model_test_too_large_avatar.instance_variables
        # puts model_test_too_large_avatar.errors.instance_variables
        # puts model_test_too_large_avatar.errors.messages
        expect(model_test_too_large_avatar.errors[:avatar]).to include 'ファイルサイズが大きすぎます。'
      end
    end

    context "ファイルの種類がjpeg, jpg, png, gif以外の時" do
      it "エラーメッセージが返る" do
        model_test_attached_not_image.valid?
        expect(model_test_attached_not_image.errors[:avatar]).to include 'ファイルが対応している画像データではありません。'
      end
    end

  end

end
