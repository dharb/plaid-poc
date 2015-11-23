class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def select_bank
    @institutions = Plaid.institution
  end

  def institutions

  end
end
