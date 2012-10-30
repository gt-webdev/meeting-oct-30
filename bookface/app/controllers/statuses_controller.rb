class StatusesController < ApplicationController
  def create
    @status = current_user.statuses.create params[:status]
    redirect_to user_path params[:user_id]
  end
  def destroy
    @status = current_user.statuses.find params[:id]
    @status.destroy
    redirect_to user_path params[:user_id]
  end
end
