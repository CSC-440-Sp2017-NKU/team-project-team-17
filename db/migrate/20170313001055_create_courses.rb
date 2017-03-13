class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.text :name
      t.integer :numQuestions
      t.text :description
      t.text :professor

      t.timestamps
    end
  end
end
