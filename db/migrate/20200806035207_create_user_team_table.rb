class CreateUserTeamTable < ActiveRecord::Migration[5.2]
  def change
    create_table :user_teams do |t|
      t.integer  :team_id
      t.integer  :user_id
    end
  end
end
