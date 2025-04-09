class ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[redirect]
  before_action :set_decode_code, only: %i[decode]

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
    if @decode
      render json: { url: @decode.origin_url }
    else
      render json: { error: "URL not found" }, status: :not_found
    end
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
    params.require(:short_link).permit(:code)
  end

  def set_decode_code
    @decode = ShortLink.find_by(code: decode_params[:code])
  end

  def set_short_link
    @short_link = ShortLink.find_by(code: params[:short_url])
  end
end
