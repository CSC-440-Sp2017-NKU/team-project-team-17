class UpdateUsersCourseId < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :course_id, :integer
  end
end
