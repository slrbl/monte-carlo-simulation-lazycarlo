class AddCostLbToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :cost_lb, :float
  end
end
