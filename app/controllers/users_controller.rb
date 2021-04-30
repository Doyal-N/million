class UsersController < ApplicationController
  def index
    @users = User.all.order(balance: :desc)
  end

  def show
    @user = User.find(params[:id])
    @games = @user.games.order(created_at: :desc)
  end
end
