class AddHasVotedOnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_voted_on, :text
  end
end
