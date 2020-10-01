class ChangeCostUbTypeToFloatInTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :cost_ub, :float
  end
end
