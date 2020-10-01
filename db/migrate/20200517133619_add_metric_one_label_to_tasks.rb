class AddMetricOneLabelToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :metric_one_label, :string
  end
end
