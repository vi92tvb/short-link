class ErrorsController < ApplicationController
  def not_found
    render json: { error: "URL not found" }, status: :not_found
  end
end
