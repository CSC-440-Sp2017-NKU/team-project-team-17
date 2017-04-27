class ChangeHasVotedOn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_voted_on_answers, :text
    rename_column :users, :has_voted_on, :has_voted_on_questions
  end
end
