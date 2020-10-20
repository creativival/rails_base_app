class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :profile, length: { maximum: Settings.user.profile_length }
  validates :avatar,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: I18n.t('errors.messages.file_type_not_image') },
            size:         { less_than: 5.megabytes,
                            message: I18n.t('errors.messages.file_too_large') }

  has_one_attached :avatar
end
