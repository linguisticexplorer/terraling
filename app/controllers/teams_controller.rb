class TeamsController < ApplicationController

    respond_to :html, :js

    def index
        @teams = Team.all

        @pagination_options = {db_mode: true, db_field: "name", default_field: "a", numbers: false, :bootstrap3 => true, :js => false}
        @teams, @params = @teams.alpha_paginate(params[:letter], @pagination_options)

        respond_to do |format|
            format.html
            format.csv { send_data Team.select("id,name,information,primary_author_id").order(:id).to_csv }
        end
    end

    def show
        @team = Team.find(params[:id])
        @users = UserTeam.page(params[:page]).users_with_team_id(params[:id])

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

        if @team.information.present? && @team.information != ""
            @output = markdown.render(@team.information)
            @output = @output.gsub("<em>","<em style='font-style: italic;'>").gsub(/<br>\s*<br>/,'<br>').gsub("<ol>","<ol style=\"list-style-type: decimal; padding-left: 40px;\">")
            @output = @output.gsub("<table>","<table style='border-spacing: 10px; border-collapse: separate;'>").gsub("<thead>",'<thead style="font-weight: bold;">').html_safe
            logger.info @output
        end

        respond_with(@team) do |format|
            format.html
        end
    end

    def new
        @team = Team.new
        is_authorized? :create, @team
    end

    def create
        @team = Team.new(team_params)
        is_authorized? :create, @team

        if @team.save
            redirect_to(@team, :notice => 'Team was successfully created.')
        else
            ender :action => "new"
        end
    end

    def edit
        @team = Team.find(params[:id])
        is_authorized? :update, @team
    end

    def update
        if params[:team].nil?
          render :action => "edit" and return
        end
    
        @team = Team.find(params[:id])
        is_authorized? :update, @team
    
        if @team.update_attributes(team_params)
          redirect_to(@team, :notice => 'Group was successfully updated.')
        else
          render :action => "edit"
        end
    end

    def destroy
        @team = Team.find(params[:id])
        is_authorized? :destroy, @team
        @team.destroy
    
        redirect_to(teams_url)
    end

    private

    def team_params
      params.require(:team).permit(:name, :website, :information, :primary_author_id)
    end

end