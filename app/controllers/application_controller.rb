class ApplicationController < ActionController::Base
  include ErrorHandler

  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token
end
