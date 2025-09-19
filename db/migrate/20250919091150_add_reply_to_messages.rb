class AddReplyToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :reply_to, null: true, foreign_key: { to_table: :messages }
  end
end
