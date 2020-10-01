class RemoveMeanFromTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :mean, :float
  end
end
