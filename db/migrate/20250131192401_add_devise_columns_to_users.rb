class AddDeviseColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :update_password, :boolean
  end
end
