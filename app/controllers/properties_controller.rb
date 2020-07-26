class PropertiesController < GroupDataController

  respond_to :html, :js

  def index
    # Added Eager Loading
    @properties = current_group.properties.includes(:category).order("name").page(params[:page])
    @properties.map { |prop| prop.get_infos } unless params[:plain]
    
    @hasCategories = current_group.categories.count > 0
    respond_with(@properties) do |format|
      format.html
      format.js
    end
  end
 
  def by_depth
    # Look for ids first, then for depth or get depth 0 by default
    condition = params[:id] ? Property.find(params[:id]).depth : params[:depth] || 0
    Rails.logger.info "\n\n\n\n\n#{current_group.properties.inspect.to_s}\n\n\n\n\n"
    render :json => current_group.properties.at_depth(condition).to_json.html_safe
  end

  def list
    @property = Property.new do |p|
      p.group = current_group
      p.creator = current_user
    end

    is_authorized? :read, @property

    render :json => current_group.properties.to_json
  end

  def show
    @property = current_group.properties.find(params[:id])

    is_authorized? :read, @property

    # Filter the number of lings to show based on the pagination
    lings = current_group.lings
    # Now get the values of the filtered lings
    lings_ids = [lings].flatten.map(&:id)
    @values = @property.lings_properties.includes(:ling).where(:ling_id => lings_ids)
    # Workout the total number of values set for this property
    @values_count = @property.lings_properties.count(:id)

    @property.get_infos

    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: {
        rel: 'nofollow',
        target: "_blank"
      },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      tables: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    if @property.description.present? && @property.description != ""
      @output = markdown.render(@property.description)
      @output = @output.gsub("<em>","<em style='font-style: italic;'>").gsub(/<br>\s*<br>/,'<br>').gsub("<ol>","<ol style=\"list-style-type: decimal; padding-left: 40px;\">")
      @output = @output.gsub("<table>","<table style='border-spacing: 10px; border-collapse: separate;'>").gsub("<thead>",'<thead style="font-weight: bold;">').html_safe
      logger.info @output
    end

    lings = []
    @values.each do |value|
      ling = {
        "name" => value.ling.name,
        "id" => value.ling.id,
        "value" => value.value
      }
      
      lings << ling
    end

    @property_obj = {
      "property_name" => @property.name,
      "property_lings" => lings
    }

    respond_to do |format|
      format.html
      format.any(:json) { send_data(JSON.generate(@property_obj).encode('utf-8'), :type => "application/json; charset=utf-8;") }
    end
    
  end

  def new
    @property = Property.new do |p|
      p.group = current_group
      p.creator = current_user
    end
    
    is_authorized? :create, @property

    @categories = get_categories
  end

  def edit
    @property = current_group.properties.find(params[:id])
    is_authorized? :update, @property

    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: {
        rel: 'nofollow',
        target: "_blank"
      },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      tables: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    

    if @property.description.present? && @property.description != ""
      @output = markdown.render(@property.description).html_safe
    end

    @categories = get_categories
  end

  def create
    @property = Property.new(property_params) do |property|
      property.group = current_group
      property.creator = current_user
    end
    is_authorized? :create, @property

    if @property.save
      redirect_to([current_group, @property],
                  :notice => (current_group.property_name + ' was successfully created.'))
    else
      @categories = get_categories
      render :action => "new"
    end
  end

  def update
    @property = current_group.properties.find(params[:id])
    is_authorized? :update, @property

    creator_id = @property.creator_id
    if params[:property]
      creator_id = params[:property][:creator_id] || creator_id
    end

    if @property.update_attribute(:creator_id, creator_id) && @property.update_attributes(property_params)
      redirect_to([current_group, @property],
                  :notice => (current_group.property_name + ' was successfully updated.'))
    else
      @categories = get_categories
      render :action => "edit"
    end
  end

  def destroy
    @property = current_group.properties.find(params[:id])
    is_authorized? :destroy, @property

    @property.destroy

    redirect_to(group_properties_url(current_group))
  end

  def property_params
    params.require(:property).permit(:name, :category_id, :description, :group_id, :team_id)
  end

  private

  def get_categories
    {:depth_0 => current_group.categories.at_depth(0),
     :depth_1 => current_group.categories.at_depth(1) }
  end
end
