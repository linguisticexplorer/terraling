class MembershipsController < GroupDataController

  respond_to :html, :js

  def index
    pagination_options = {db_mode: true, db_field: "name", default_field: "a", :bootstrap3 => true, :js => false}
    @memberships, @params = current_group.memberships.
        includes(:member).to_a.
        select { |membership| membership.member.present? }.
        alpha_paginate(params[:letter], pagination_options) do |membership|
          user = membership.member
          user.present? ? user.name : '*'
        end

    respond_with(@memberships) do |format|
      format.html
      format.js
    end
  end

  def contributors
    pagination_options = {db_mode: true, db_field: "name", default_field: "a", :bootstrap3 => true, :js => false}

    @contributors, @params = current_group.memberships.
      includes(:member).with_role(:expert, :any).to_a.
      select { |membership| membership.member.present? }.
      uniq.
      alpha_paginate(params[:letter], pagination_options) do |membership|
          user = membership.member
          user.present? ? user.name : '*'
        end
    
    @resources = @contributors.map  do |contributor|
      ids = current_group.lings.find_roles(:expert, contributor).map { |role| role.resource_id }

      current_group.lings.find(ids)
    end

    respond_with(@contributors) do |format|
      format.html
      format.js
    end
  end
  
  def list
    memberships = current_group.memberships.includes(:member)

    members = []

    memberships.each do |membership|
      next if membership.member.nil?

      members << membership.member
    end

    render :json => members.to_json.html_safe
  end

  def show
    @membership = current_group.memberships.find(params[:id])

    is_authorized? :read, @membership

    resource_ids = @membership.roles.map(&:resource_id)

    @lings = current_group.lings.find(resource_ids)

    if @membership.is_expert?
      # Just Lings for the moment
      @activities = current_group.lings.where({:id => resource_ids, :creator_id => @membership.id}).order(:updated_at).first(25)
    end

    respond_with(@membership) do |format|
      format.html
      format.js
    end
  end

  def new
    @membership = Membership.new do |m|
      m.group = current_group
      m.creator = current_user
    end
    is_authorized? :create, @membership

    @users = User.all
  end

  def edit
    @membership = current_group.memberships.find(params[:id])
    is_authorized? :update, @membership
    
    # Stick with Ling for the moment, then will group by resource type and query them
    @lings = Ling.find(@membership.roles.map(&:resource_id))

    @users = User.all
  end

  def create
    attributes, roles = get_attributes_and_roles
      
    @membership = Membership.new(attributes) do |membership|
      membership.group = current_group
      membership.creator = current_user
    end

    is_authorized? :create, @membership

    if @membership.save
      # Set the expertise in all the passed resources
      if roles[:role] && roles[:resources].any?
        @membership.set_expertise_in roles[:resources]
      end
      redirect_to([current_group, @membership],
                  :notice => 'Membership was successfully created.')
    else
      @users = User.all
      render :action => "new"
    end
  end

  def update
    if params[:membership].nil?
      render :action => "edit" and return
    end

    @membership = current_group.memberships.find(params[:id])

    is_authorized? :update, @membership

    attributes, roles = get_attributes_and_roles

    if @membership.update_attributes(attributes)
      # Set the expertise in all the passed resources
      if roles[:role] && roles[:resources].any?
        @membership.set_expertise_in roles[:resources]
      end
      redirect_to([current_group, @membership], :notice => 'Membership was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @membership = current_group.memberships.find(params[:id])
    is_authorized? :destroy, @membership

    @membership.destroy

    redirect_to(group_memberships_url(current_group))
  end

  def membership_params
    params.require(:membership).permit!
  end

  private

  def get_attributes_and_roles
    attributes = {}
    roles = {}

    if params[:membership]
      m_params = params.require(:membership).permit! || {}
      selected_role = m_params[:role] || ''

      level = m_params[:level] || selected_role
      role = selected_role

      if(Membership::ROLES.include?(level))
        level = 'member'
        role  = selected_role
      end

      attributes[:level] = level
      attributes[:member_id] = m_params[:member_id] if m_params[:member_id]


      roles = {
        :role => role,
        :resources => current_group.lings.find((m_params[:resources] || '').split(';'))
      }
    else
      # TODO: refactor this horrible code!
      accessible = Membership.new.attributes
      params.each do |key, value|
        case key
        when :role
          roles[key] = value
        when :resources
          roles[key] = current_group.lings.find((value || '').split(';')) if key == :resources
        else
          attributes[key] = value if accessible.include? key
        end
      end
    end

    [attributes, roles]
  end
end
