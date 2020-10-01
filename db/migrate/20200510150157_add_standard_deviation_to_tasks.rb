class AddStandardDeviationToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :stdrd_deviation, :float
  end
end
