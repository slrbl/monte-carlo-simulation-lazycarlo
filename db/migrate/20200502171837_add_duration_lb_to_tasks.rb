class AddDurationLbToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :duration_lb, :integer
  end
end
