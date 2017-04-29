class ChangeUserCourseToJoin < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :courses
    remove_column :users, :course_id
  end
end
