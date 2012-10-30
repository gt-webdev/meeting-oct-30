class UsersController < ApplicationController
  def index
  end
  def show
    @user = User.find(params[:id])
    @status = current_user.statuses.build
    @statuses = @user.statuses
  end
end
