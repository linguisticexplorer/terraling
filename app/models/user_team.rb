class UserTeam < ApplicationRecord

    validates_presence_of :user_id, :team_id

    belongs_to :user
    belongs_to :team

    scope :users_with_team_id, -> (team_id) { where( :team_id => team_id ) }
    scope :teams_with_user_id, -> (user_id) { where( :user_id => user_id ) }

end