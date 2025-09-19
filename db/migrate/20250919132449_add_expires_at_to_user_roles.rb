class AddExpiresAtToUserRoles < ActiveRecord::Migration[8.0]
  def change
    add_column :user_roles, :expires_at, :datetime
  end
end
