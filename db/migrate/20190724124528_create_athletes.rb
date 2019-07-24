class CreateAthletes < ActiveRecord::Migration[5.2]
  def change
    create_table :athletes do |t|
      t.string :name
      t.string :line_id
      t.string :line_name

      t.timestamps
    end
  end
end
