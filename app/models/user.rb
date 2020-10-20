class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :profile, length: { maximum: Settings.user.profile_length }

  has_one_attached :avatar

  def display_avatar_large
    avatar.variant(gravity: :center, resize:"240x240^", crop:"240x240+0+0").processed
  end

  def display_avatar_middle
    avatar.variant(gravity: :center, resize:"120x120^", crop:"120x120+0+0").processed
  end

  def display_avatar_small
    avatar.variant(gravity: :center, resize:"80x80^", crop:"80x80+0+0").processed
  end
end
