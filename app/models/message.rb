class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :reply_to, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: "reply_to_id", dependent: :nullify

  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc).limit(50) }

  def reply?
    reply_to.present?
  end
end
