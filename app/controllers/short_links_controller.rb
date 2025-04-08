class ShortLinksController < ApplicationController
  def encode
    short_code = UrlEncodeService.call(short_link_params[:url])

    render json: { short_url: short_code }
  end

  private
  def short_link_params
    params.require(:short_link).permit(:url)
  end
end
