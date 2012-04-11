class Api::RocksController < Api::ApplicationController
  def index
    respond_with(@rocks = Rock.all)
  end
  
  def show
    respond_with(@rock = Rock.find_by_id(params[:id]))
  end
end
