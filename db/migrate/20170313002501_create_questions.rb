class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.integer :course_id
      t.text :title
      t.integer :user_id
      t.text :content
      t.integer :num_answers

      t.timestamps
    end
  end
end
