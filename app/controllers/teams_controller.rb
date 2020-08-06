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
        @users = User.page(params[:page]).with_team_id(params[:id])

        is_authorized? :read, @team

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
    end

    def update
    end

    def destroy
    end

    private

    def team_params
      params.require(:team).permit(:name, :website, :information)
    end

end