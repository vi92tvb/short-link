class ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[redirect]

  # POST /encode
  # Encodes a long URL into a short URL with a domain.
  def encode
    short_code = UrlEncodeService.call(encode_params[:url])

    domain = ENV["APP_DOMAIN"] || "http://localhost:3000"

    render json: { short_url: "#{domain}/#{short_code}" }
  end

  # POST /decode
  # Decodes a short code back to the original long URL.
  def decode
    url = UrlDecodeService.call(decode_params[:url])

    render json: { url: url }
  end

  # GET /:short_url
  # Redirects to the original URL based on the short code.
  def redirect
    if @short_link
      redirect_to @short_link.origin_url, allow_other_host: true
    else
      render json: { error: "URL not found" }, status: :not_found
    end
  end

  private
  def encode_params
    params.require(:short_link).permit(:url)
  end

  def decode_params
    params.require(:short_link).permit(:url)
  end

  def set_short_link
    @short_link = ShortLink.find_by(code: params[:short_url])
  end
end
