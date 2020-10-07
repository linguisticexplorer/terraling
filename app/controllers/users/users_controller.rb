class Users::UsersController  < ApplicationController
  before_action :require_admin, only: [:index, :create]
  before_action :require_admin_or_self, only: [:show, :update]

  def index

    @new_users = User.new_user
    @old_users = User.not_new_user

    @pagination_options = {db_mode: true, db_field: "name", default_field: "a", numbers: false, :bootstrap3 => true, :js => false}
    @users, @params = @old_users.alpha_paginate(params[:letter], @pagination_options)

    respond_to do |format|
      format.html
      format.csv { send_data User.not_new_user.select("id,name,email,access_level").order(:id).to_csv }
    end
  end

  def show
    @user = User.find(params[:id])
    get_data
  end

  def update
    @user = User.find(params[:id])

    if params[:resource] && current_user.admin?
      if params[:resource][:id].blank?
        member = Membership.where(member_id: @user.id).first || Membership.new(member_id: @user.id)
      else
        member = Membership.where( member_id: @user.id, group_id: params[:resource][:id]).first || Membership.new(member_id: @user.id)
      end
      if !params[:ling][:id].blank?
        member.add_expertise_in Ling.find_by_id(params[:ling][:id])
      else
        member.group_id = params[:resource][:id] unless params[:resource][:id].blank?
        member.level = params[:membership][:level] unless params[:resource][:id].blank?
      end
      member.save!
    end

    if params[:remove] && current_user.admin?
      params[:remove].each do |id|
        Membership.delete(id)
      end
    end

    if params[:remove_role] && current_user.admin?
      params[:remove_role].each do |id|
        Membership.find_by_member_id(@user.id).remove_expertise_in(Ling.find_by_id(id))
      end
    end

    if params[:userteams] && current_user.admin?
      userteams = UserTeam.teams_with_user_id(params[:id]).all
      userteams.each do |ut|
        ut.destroy!
      end

      params[:userteams].each do |id|
        user_team = UserTeam.where(user_id: @user.id).where(team_id: id).first || UserTeam.new(user_id: @user.id, team_id: id)

        user_team.save!
      end
    end

    @user.name = params[:name] unless params[:name].blank?
    @user.website = params[:website] unless params[:website].blank?

    if current_user.admin?
      @user.email = params[:email] unless params[:email].blank?
      @user.access_level = params[:access_level][:level] unless params[:access_level].blank?
    end

    @user.save!

    get_data
    redirect_to :action => 'show'
  end


  def destroy
    User.delete(params[:id]) unless params[:id].eql? current_user.id
    
    @new_users = User.new_user
    @old_users = User.not_new_user

    @pagination_options = {db_mode: true, db_field: "name", default_field: "a", numbers: false, :bootstrap3 => true, :js => false}
    @users, @params = @old_users.alpha_paginate(params[:letter], @pagination_options)

    render :index
  end

  private

  def get_data
    memberships = Membership.where(:member_id => @user.id)
    @memberships = []
    memberships.each do |membership|
      hash = {}
      next if membership.role.nil? || Group.find_by_id(membership.group_id).nil?
      hash[:id] = membership.id
      hash[:group_name] = Group.find_by_id(membership.group_id).name
      hash[:role] = membership.role
      @memberships << hash
    end

    @roles = []
    memberships.each do |membership|
      membership.roles.each do |role|
        next if role.resource_type.eql?"Group"
        hash = {}
        hash[:id] = role.resource_id
        hash[:role] = role.name
        hash[:ling_name] = Ling.find_by_id(role.resource_id).name
        @roles << hash
      end
    end

    group_id_member = []
    memberships.each do |membership|
      group_id_member << Group.find_by_id(membership.group_id)
    end
    group_id_member = group_id_member.compact

    @role_resources = [['','']] + (group_id_member.collect { |group| group.lings.collect {|d| {d.name => d.id}} }.flatten.collect{|s| s.to_a.flatten})

    @membership_levels = [Membership::ACCESS_LEVELS].flatten
    @role_levels = [Membership::ROLES].flatten
    @group_names = [['','']] +  Group.all.collect{|g| [g.name, g.id]}

  end

  def require_admin
    render :unauthorized unless current_user && current_user.admin?
  end

  def require_admin_or_self
    render :unauthorized unless (current_user && params[:id].to_i == current_user.id) || current_user.admin?
  end
end
