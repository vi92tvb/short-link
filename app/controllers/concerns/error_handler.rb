module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from UrlDecodeService::InvalidDomainError, with: :render_invalid_domain
    rescue_from UrlDecodeService::UrlNotFoundError, with: :render_url_not_found
  end

  private

  def render_unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages[0] }, status: :unprocessable_entity
  end

  def render_invalid_domain(_exception)
    render json: { error: "Invalid domain" }, status: :unprocessable_entity
  end

  def render_url_not_found(_exception)
    render json: { error: "URL not found" }, status: :not_found
  end
end
