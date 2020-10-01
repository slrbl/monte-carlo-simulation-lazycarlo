class AddMetricOneLabelToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :metric_one_label, :string
  end
end
