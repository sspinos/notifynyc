class Api::MetricsController < Api::ApplicationController
  def index
    if params["sSearch"].present?
      @metrics = Metric.search(params["sSearch"])
    else
      @metrics = Metric.all  
    end
    
    respond_with(@metrics)
  end
  
  def show
    respond_with(@metric = Metric.find_by_id(params[:id]))
  end
end
