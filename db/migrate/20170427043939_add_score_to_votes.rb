class AddScoreToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :score, :integer
  end
end
