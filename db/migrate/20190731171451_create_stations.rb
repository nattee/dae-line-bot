class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations, :options => 'COLLATE=utf8_general_ci' do |t|
      t.references :course, foreign_key: true
      t.string :code
      t.string :shortname
      t.string :name
      t.float :distance
      t.datetime :cutoff

      t.timestamps
    end
  end
end
