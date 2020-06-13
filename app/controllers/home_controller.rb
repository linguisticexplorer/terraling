class HomeController < ApplicationController
  def index
    @groups = if user_signed_in?
      Group.accessible_by(current_ability).uniq
    else
      Group.is_public
    end
    @group = params[:group_id] && Group.find(params[:group_id]) || current_group
  end
end
