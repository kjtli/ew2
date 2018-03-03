class Heading < ApplicationRecord
  belongs_to :member
  
  # show most recent heading first
  default_scope -> { order(created_at: :desc) }
  
  validates :member_id, presence: true
  validates :content, presence: true
  
end
