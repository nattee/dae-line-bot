class CreateRuns < ActiveRecord::Migration[5.2]
  def change
    create_table :runs do |t|
      t.references :athlete, foreign_key: true
      t.string :bib
      t.references :course, foreign_key: true
      t.float :current_dist
      t.string :status

      t.timestamps
    end
  end
end
