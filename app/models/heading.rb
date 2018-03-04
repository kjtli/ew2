class Heading < ApplicationRecord
  belongs_to :member
  
  # show headings in reverse chronological order
  default_scope -> { order(created_at: :desc) }
  
  validates :member_id, presence: true
  validates :content, presence: true
  
  # partial match search excluding current member
  def self.search(args = {})
    s_text = args[:search_text]
    member = args[:member]
    if !s_text.blank? && member.present?
      partial_match = "%#{s_text.downcase}%"
      # todo: pagination
      # investigate what Arel is about...
      where("lower(content) LIKE ? AND member_id != ?", partial_match, member.id)
    end
  end
  
end
