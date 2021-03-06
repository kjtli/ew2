class MembersController < ApplicationController
  
  def index
    @members = Member.all
  end
  
  # disabled for now
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
    
    # search experts, if any.
    # Notes: per discussion with Dustin, Members, who are not friends, do not need a common friend to be qualified for search results.  
    # e.g. Alan -> Claudia ("Dog breeding in Ukraine") instead of Alan -> Bart -> Claudia ("Dog breeding in Ukraine").
    search_experts({ :search_text => params[:search_text],
                     :friend_ids => friend_ids })
                     
  end

  # todo - not working yet...
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
      @experts = []
      if s_text.present?
        search_args = { :search_text => s_text, :member => @member}
        heading_results = Heading.search(search_args)
        
        if heading_results.any?
          # process resuts
          heading_results.each do |hr|
            puts "hr:" + hr.to_s
            hr_member_id = hr.member.id
            next if friend_ids.any? && friend_ids.include?(hr_member_id)
            @experts << { :member_id => hr_member_id, :name => hr.member.name, :heading => hr.content}
          end
        end
        
        @search_no_results_msg = "No results found" if @experts.blank?

      end
    end

end
