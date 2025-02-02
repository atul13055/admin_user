class AddLocationFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :other_city, :string

    # Adding password_digest column for secure password storage
    add_column :users, :password, :string
    add_column :users, :encrypted_password,:string, null: false, default: ""
    add_column :users, :role, :integer
    # Adding status column with default value of false
    add_column :users, :status, :boolean, default: false
  end
end
