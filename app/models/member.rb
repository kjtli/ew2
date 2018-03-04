class Member < ApplicationRecord
  # removing child heading and friend records when a member is deleted.
  has_many :headings, dependent: :destroy
  has_many :friends, dependent: :destroy
  
  validates :name, presence: true
  validates :pws_full_url, presence: true
  
  def self.find_by_ids(*ids)
    if ids.any?
      where(id: ids)
    end
  end
  
end
