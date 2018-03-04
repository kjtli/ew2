class MembersController < ApplicationController
  
  def index
    @members = Member.all
  end
  
  def new
    @member = Member.new
  end

  def show
    @member = Member.find(params[:id])
    @headings = @member.headings

    # get friends, if any.
    friend_ids = @member.friends.pluck(:friend_id)
    if friend_ids.any?
      # get member objects for the friends
      @friends_data = Member.find_by_ids(friend_ids)
    end
    
    # get experts, if any.
    search_experts({ :search_text => params[:search_text],
                     :friend_ids => friend_ids })
                     
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
    
    def search_experts(args = {})
      s_text = args[:search_text]
      friend_ids = args[:friend_ids]
      if s_text.present?
        search_args = { :search_text => s_text, :member => @member}
        heading_results = Heading.search(search_args)
        if heading_results.any?
          @experts = []
          # process resuts
          heading_results.each do |hr|
            hr_member_id = hr.member.id
            if friend_ids.any?
              # exclude member's friends
              if !friend_ids.include?(hr_member_id)
                @experts << { :member_id => hr_member_id, :name => hr.member.name, :heading => hr.content}
              end
            else
              # member has no friends yet
              @experts << { :member_id => hr_member_id, :name => hr.member.name, :heading => hr.content}
            end
          end
        else
          @search_no_results_msg = "No results found"
        end
      end
    end

end
