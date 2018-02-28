class MembersController < ApplicationController
  
  def index
    @members = Member.all
    # todo - need to get number of friends, if any, for each member from MemberFriend
  end
  
  def new
    @member = Member.new
  end
  
  def show
    @member = Member.find(params[:id])
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
