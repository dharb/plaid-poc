require 'plaid'
class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  def update
    @bank_account = BankAccount.find(params[:id])
    @user = @bank_account.user
    unless @user == current_user
      redirect_to :back, alert: "Access denied."
    end
    account_id = params[:bank_account][:account_id]
    funding_amount = params[:bank_account][:funding_pending_amount]
    if @bank_account.account_id.nil? || @bank_account.account_id == account_id
      @bank_account.update!(account_id: account_id, funding_pending_amount: funding_amount)
    else
      @bank_account = @user.bank_accounts.where(plaid_public_token: @bank_account.plaid_public_token, plaid_access_token: @bank_account.plaid_access_token, account_id: account_id, funding_pending_amount: funding_amount).first_or_create!
    end
    respond_to do |format|
      format.js   {
        head :ok
      }
    end
  end
end
