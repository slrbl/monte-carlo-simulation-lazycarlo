class AddMetricTwoLabelToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :metric_two_label, :string
  end
end
