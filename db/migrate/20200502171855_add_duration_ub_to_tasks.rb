class AddDurationUbToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :duration_ub, :integer
  end
end
