class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.references :run, foreign_key: true
      t.references :station, foreign_key: true
      t.integer :total_minute
      t.datetime :worldtime
      t.integer :margin_minute
      t.string :pace

      t.timestamps
    end
  end
end
