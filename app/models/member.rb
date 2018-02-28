class Member < ApplicationRecord
  has_many :member_headings
  has_many :member_friends
  
  validates :name, presence: true
  validates :pws_full_url, presence: true
  
end
