class AddGainToStation < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :ascent, :integer
    add_column :stations, :descent, :integer
    add_column :stations, :chilling_trail_time_minute, :integer
  end
end
