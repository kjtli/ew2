class Member < ApplicationRecord
  # removing child heading and friend records when a member is deleted.
  has_many :headings, dependent: :destroy
  has_many :friends, dependent: :destroy
  
  validates :name, presence: true
  validates :pws_full_url, presence: true
  
end
