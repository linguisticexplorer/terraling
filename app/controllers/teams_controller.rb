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