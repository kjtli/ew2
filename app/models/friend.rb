class Friend < ApplicationRecord
  belongs_to :member
  
  # show friends in reverse chronological order
  default_scope -> { order(created_at: :desc) }
  
  validates :member_id, presence: true
  validates :friend_id, presence: true
  
end
