class Team < ApplicationRecord
    include CSVAttributes
  
    CSV_ATTRIBUTES = %w[ id name information primary_author_id ]
    def self.csv_attributes
      CSV_ATTRIBUTES
    end

    validates_presence_of :name, :website

    has_many :user_teams
    has_many :users, :through => :user_teams

    def primary_author
        if self.primary_author_id
            User.find(self.primary_author_id).try(:name)
        else
            nil
        end
    end

    def num_users
        UserTeam.users_with_team_id(self.id).count
    end

end