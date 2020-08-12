class AddTeamIdToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :team_id, :integer, :default => nil
  end
end
