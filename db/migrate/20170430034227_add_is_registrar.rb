class AddIsRegistrar < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_registrar, :boolean
  end
end
