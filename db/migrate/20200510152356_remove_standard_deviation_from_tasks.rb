class RemoveStandardDeviationFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :stdrd_deviation, :float
  end
end
