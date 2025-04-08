class ShortLinksController < ApplicationController
  before_action :set_short_link, only: %i[redirect]
  before_action :set_decode_code, only: %i[decode]

  def encode
    short_code = UrlEncodeService.call(encode_params[:url])

    render json: { short_url: short_code }
  end

  def decode
    if @decode
      render json: { url: @decode.origin_url }
    else
      render json: { error: 'URL not found' }, status: :not_found
    end
  end

  def redirect
    if @short_link
      redirect_to @short_link.origin_url, allow_other_host: true
    else
      render json: { error: 'URL not found' }, status: :not_found
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
