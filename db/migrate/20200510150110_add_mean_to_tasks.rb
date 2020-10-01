class AddMeanToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :mean, :float
  end
end
