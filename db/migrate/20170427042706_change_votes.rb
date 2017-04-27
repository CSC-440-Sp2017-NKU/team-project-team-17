class ChangeVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :user_id, :integer
    add_column :votes, :question_id, :integer
    add_column :votes, :answer_id, :integer
  end
end
