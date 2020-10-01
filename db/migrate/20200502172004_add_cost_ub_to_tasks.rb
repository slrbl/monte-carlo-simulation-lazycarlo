class AddCostUbToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :cost_ub, :integer
  end
end
