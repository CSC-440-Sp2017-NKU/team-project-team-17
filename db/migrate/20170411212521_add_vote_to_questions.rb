class AddVoteToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :votes, :integer
    add_column :answers, :votes, :integer
  end
end
