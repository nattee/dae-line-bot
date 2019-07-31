class AddGainToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :gain, :float
  end
end
