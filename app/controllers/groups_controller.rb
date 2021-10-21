class GroupsController < ApplicationController

  respond_to :html, :js

  # To add paginate method in Array class
  # https://github.com/mislav/will_paginate/wiki/Backwards-incompatibility
  require 'will_paginate/array'

  def index
    if params[:group_id]
      begin
        @group = Group.find(params[:group_id])
        is_authorized? :show, @group
        redirect_to @group
        return
      rescue ActiveRecord::RecordNotFound
      end
    end

    @groups = if user_signed_in?
      @groups = Group.page(params[:page]).order("name").accessible_by(current_ability).distinct
    else
      Group.page(params[:page]).order("name").is_public
    end

    respond_with(@groups) do |format|
      format.html
      format.json {render @groups.to_json(:except => [:created_at, :updated_at, :display_style], :root => true).html_safe}
    end


  end

  def list
    @groups = if user_signed_in?
      Group.accessible_by(current_ability).distinct
    else
      Group.is_public
    end
    # Check for each group when the last change on lings has been done,
    # and attach to it
    render :json => @groups.to_json(:except => [:created_at, :updated_at, :display_style], :root => true).html_safe
  end

  def show
    @group = Group.find(params[:id])
    is_authorized? :show, @group

    respond_with(@group) do |format|
      format.html
      format.json {render @group.to_json(:except => [:created_at, :updated_at, :display_style], :root => true).html_safe}
    end

  end

  def new
    @group = Group.new
    is_authorized? :create, @group
  end

  def edit
    @group = Group.find(params[:id])
    is_authorized? :update, @group
  end

  def create
    @group = Group.new(group_params)
    is_authorized? :create, @group

    if @group.save
      redirect_to(@group, :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if params[:group].nil?
      render :action => "edit" and return
    end

    @group = Group.find(params[:id])
    is_authorized? :update, @group

    if @group.update_attributes(group_params)
      redirect_to(@group, :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    is_authorized? :destroy, @group
    @group.destroy

    redirect_to(groups_url)
  end

  def user
    @groups = if user_signed_in?
      Group.accessible_by(current_ability).distinct.order("name").page(params[:page])
    else
      Group.is_public.order("name").page(params[:page])
    end
  end

  def activity
    @group = Group.find(params[:id])
    is_authorized? :manage, @group
    @list = []
    [Example, Property, Ling].each do |resources|
      resources.where("updated_at between date_sub(now(),INTERVAL 2 WEEK) and now() AND group_id = #{params[:id]}").each do |resource|
        next if resource.creator_id.nil?
        user = User.find_by_id(resource.creator_id)
        next if user.nil?
        @list << { user: user, resource: resource}
      end
    end
    @list = @list.sort_by {|item| item[:resource].updated_at }.reverse!
  end
  private

  def current_group
    #params[:group_id] && Group.find(params[:group_id]) || @group
    @group
  end

  def group_params
    params.require(:group).permit(
      :name, 
      :group, 
      :examples_lings_properties, 
      :ling0_name, 
      :ling1_name, 
      :depth_maximum, 
      :privacy,
      :example_fields,
      :depth_maximum,
      :ling_fields,
      :category_name,
      :property_name,
      :lings_property_name,
      :example_name,
      :examples_lings_property_name,
      :display_style
    )
  end
end
