class RemoveIpAddressFromActivityLogs < ActiveRecord::Migration[8.0]
  def change
    remove_column :activity_logs, :ip_address, :string
  end
end
