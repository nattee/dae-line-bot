class AddCtToRun < ActiveRecord::Migration[5.2]
  def change
    add_column :runs, :ct_station, :string
    add_column :runs, :ct_checkin_time, :datetime
    add_column :runs, :ct_distance, :float
  end
end
