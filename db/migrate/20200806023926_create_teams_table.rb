class CreateTeamsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :teams, :force => true do |t|
      t.string   :name
      t.string   :website
      t.text     :information
      t.integer  :primary_author_id

      t.timestamps
    end
  end
end
