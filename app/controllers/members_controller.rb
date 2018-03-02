class MembersController < ApplicationController
  
  def index
    @members = Member.all
    # todo - need to get number of friends, if any, for each member from MemberFriend
  end
  
  def new
    @member = Member.new
  end

=begin

1. first query returns all headings that match search text but not owned by current member

SELECT m1.id, m1.name, mh.heading
FROM MemberHeadings mh
  JOIN Members m1
  ON mh.member_id = m1.id
WHERE mh.heading LIKE "%?%" // ? contains search text; it may need to handle SQL unsafe characters...
  AND mh.member_id IN
    (SELECT m2.id
     FROM Members m2
     WHERE m2.id != ?);  // ? contains current member id

2. if experts are found, returns experts who are not friends of current member

SELECT m.name, m.id
FROM Members m
WHERE m.id IN (?, ?, ...) AND m.id NOT IN  // ? contains expert member ids from first query
(SELECT mf.friend_id
FROM MemberFriends mf
WHERE mf.member_id = ?); // ? contains current member id

=end

  def show
    @member = Member.find(params[:id])
    
    @s_text = params[:search_text]
    if @s_text.present?
      # 1. query MemberHeadings for matching text, get back a list of experts (members), if any, excluding current member.
      # @all_experts = ...
      # 2. returns experts who are not friends of current member
      # @experts
    end
  end
  
  def create
    @member = Member.new(member_params)
    # todo - need shorten url gem or web service
    @member.pws_short_url = "todo"
    
    if @member.save
      # todo: fetch headings, if any, from personal website and save them to MemberHeading
      # show all members
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end
  
  private
  
    def member_params
      params.require(:member).permit(:name, :pws_full_url)
    end
end
