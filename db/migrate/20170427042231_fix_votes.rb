class FixVotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :has_voted_on_answers
    remove_column :users, :has_voted_on_questions
    remove_column :questions, :votes
    remove_column :answers, :votes
  end
end
