class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plaid_access_token, :string
  end
end
