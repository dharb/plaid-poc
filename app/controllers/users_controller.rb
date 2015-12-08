require 'plaid'
class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def select_bank
    @institutions = Plaid.institution
  end

  def funding
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, alert: "Access denied."
    end
    if @user.plaid_access_token.blank? && params[:public_token].present?
      public_token = params[:public_token]
      exchange_token_response = Plaid.exchange_token(public_token) rescue nil
      if exchange_token_response.nil?
        access_token = nil
      else
        access_token = exchange_token_response.access_token
        @user.update_attributes(plaid_access_token: access_token, plaid_public_token: public_token)
      end
    else
      access_token = @user.plaid_access_token
    end
    if access_token.present?
      plaid_user = Plaid.set_user(access_token, ['auth'])
      plaid_user.get('auth')
      @accounts = plaid_user.accounts.map do |account|
        {
          balance: {
            available: account.available_balance,
            current: account.current_balance
          },
          meta: account.meta,
          type: account.type,
          account_id: account.id
        }
      end
    else
      redirect_to select_bank_user_path(@user), alert: "You must authenticate with your bank first."
    end
  end

end
