class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.integer :user_id
      t.string :plaid_access_token
      t.string :plaid_public_token
      t.string :account_id
      t.string :account_type
      t.string :bank_name
      t.integer :funding_pending_amount, default: 0
      t.boolean :primary, default: false
    end
  end
end
