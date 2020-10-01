class ChangeDurationToFloatInTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :duration_lb, :float
    change_column :tasks, :duration_ub, :float
  end
end
