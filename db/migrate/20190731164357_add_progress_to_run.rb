class AddProgressToRun < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :start_time, :datetime
    add_column :runs, :station, :string
    add_column :runs, :last_online_call_timestamp, :datetime
  end
end
