class AddMsgTypeToDirectResponse < ActiveRecord::Migration[5.2]
  def change
    add_column :direct_responses, :msg_type, :integer, default: 0
  end
end
