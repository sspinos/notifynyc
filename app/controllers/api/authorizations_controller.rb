class Api::AuthorizationsController < Api::ApplicationController
  def index
    respond_with(@authorizations = Authorization.all)
  end
  
  def show
    respond_with(@authorization = Authorization.find_by_id(params[:id]))
  end
end
