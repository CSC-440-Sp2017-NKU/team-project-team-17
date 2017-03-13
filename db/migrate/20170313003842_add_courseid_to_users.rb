class AddCourseidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :course_id, :string
    remove_column :questions, :num_answers
    remove_column :courses, :numQuestions
  end
end
