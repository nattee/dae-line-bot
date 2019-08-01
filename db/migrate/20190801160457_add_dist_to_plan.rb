class AddDistToPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :dist, :float
  end
end
