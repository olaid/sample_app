class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  scope :including_replies, -> (user){ where("in_reply_to=?",user.id) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  before_save :create_reply_id

  private
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def create_reply_id
      if (reply_name = self.content.match(/@([^ ]*)/))
        reply_user = User.where("nickname like ?",reply_name[1])
        self.in_reply_to = reply_user.first.id
      end
    end
end
