class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from UrlDecodeService::InvalidDomainError, with: :render_invalid_domain
  rescue_from UrlDecodeService::UrlNotFoundError, with: :render_url_not_found

  private

  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_invalid_domain(exception)
    render json: { error: "Invalid domain" }, status: :unprocessable_entity
  end

  def render_url_not_found(exception)
    render json: { error: "URL not found" }, status: :not_found
  end
end
