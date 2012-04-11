class Api::UsersController < Api::ApplicationController
  def index
    respond_with(@users = User.all)
  end
  
  def show
    respond_with(@user = User.find_by_id(params[:id]))
  end
end
