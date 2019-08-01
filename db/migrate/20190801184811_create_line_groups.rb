class CreateLineGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :line_groups do |t|
      t.references :race, foreign_key: true
      t.string :line_group_id
      t.string :line_id

      t.timestamps
    end
  end
end
