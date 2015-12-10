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
    if @user.primary_account.present?
      if params[:public_token].present?
        public_token = params[:public_token]
        exchange_token_response = Plaid.exchange_token(public_token) rescue nil
        if exchange_token_response.nil?
          access_token = nil
        else
          access_token = exchange_token_response.access_token
          @bank_account = @user.bank_accounts.where(plaid_public_token: public_token, plaid_access_token: access_token).first_or_create!
          @bank_account.save
        end
      else
        @bank_account = @user.primary_account
        access_token = @bank_account.plaid_access_token
      end
    else
      if params[:public_token].present?
        public_token = params[:public_token]
        exchange_token_response = Plaid.exchange_token(public_token) rescue nil
        if exchange_token_response.nil?
          access_token = nil
        else
          access_token = exchange_token_response.access_token
          @bank_account = @user.bank_accounts.build(plaid_public_token: public_token, plaid_access_token: access_token, primary: true)
          @bank_account.save
        end
      else
        redirect_to :back, alert: "Something went wrong, please try again."
      end
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
