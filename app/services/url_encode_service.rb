require "base62"

class UrlEncodeService < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    resource = ShortLink.find_by(origin_url: @url)

    resource ? resource.code : ShortLinkGeneratorService.call(@url)
  end
end
