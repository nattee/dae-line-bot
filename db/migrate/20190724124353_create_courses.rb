class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.references :race, foreign_key: true
      t.string :title
      t.float :distance
      t.datetime :start
      t.datetime :stop

      t.timestamps
    end
  end
end
