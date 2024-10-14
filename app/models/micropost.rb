class Micropost < ApplicationRecord
  belongs_to :user # 一つのuserしか持ってない
  # has_one_attached :image # active storageと紐づけ

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  default_scope -> { order(created_at: :desc) } # 新しい順で
  validates :user_id, presence: true # 存在しているかどうか
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/png image/gif],
                                    message: '指定された画像フォーマットにしてください(jpeg,png,gif)' },
                    size: { less_than: 5.megabytes,
                            message: '5mb以下にしてくださいね' } # :imageのvalidationはactive_storage_validationsによるもの
end
