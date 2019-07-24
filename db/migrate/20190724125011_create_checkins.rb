class CreateCheckins < ActiveRecord::Migration[5.2]
  def change
    create_table :checkins do |t|
      t.references :run, foreign_key: true
      t.float :distance
      t.datetime :time
      t.string :type
      t.string :location
      t.string :remark

      t.timestamps
    end
  end
end
