class AddPublicTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plaid_public_token, :string
  end
end
