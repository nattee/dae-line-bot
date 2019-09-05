class CreateDirectResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_responses do |t|
      t.integer :tag
      t.string :text
      t.string :response

      t.timestamps
    end
  end
end
