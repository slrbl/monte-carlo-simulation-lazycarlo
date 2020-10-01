class AddMetricTwoLabelToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :metric_two_label, :string
  end
end
