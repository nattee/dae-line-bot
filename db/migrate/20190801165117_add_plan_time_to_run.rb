class AddPlanTimeToRun < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :plan_hour, :float
  end
end
