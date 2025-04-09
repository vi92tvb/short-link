require "base62"

class UrlEncodeService < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    ShortLinkGeneratorService.call(@url)
  end
end
