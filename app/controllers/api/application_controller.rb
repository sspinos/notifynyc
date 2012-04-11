class Api::ApplicationController < ApplicationController
  respond_to :csv, :json
  before_filter :authentication_check
  
  private
  
  def authentication_check
    authenticate_or_request_with_http_basic do |token, secret|
      Authorization.find_by_token_and_secret(token, secret).present?
      #true
    end
    @domain_key = Rails.env == "development" ? "http://175164762-huuIAwF6oFnZBXcfH2abd54qrnMIovATfb9MVveI:K4k5lrsSGpc9Sl3Ve1t9ceR7ZcyxrfaSIeOkpGxRE@localhost:3000":"http://175164762-huuIAwF6oFnZBXcfH2abd54qrnMIovATfb9MVveI:K4k5lrsSGpc9Sl3Ve1t9ceR7ZcyxrfaSIeOkpGxRE@notifynyc.herokuapp.com"
  end
end
