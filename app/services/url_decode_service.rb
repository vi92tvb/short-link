class UrlDecodeService < ApplicationService
  class InvalidDomainError < StandardError; end
  class UrlNotFoundError < StandardError; end

  def initialize(url)
    @url = url
    @domain = ENV["APP_DOMAIN"] || "http://localhost:3000"
    @short_link = nil
  end

  def call
    validate_domain!

    code = @url.sub(@domain + "/", "")

    find_short_link(code)
    validate_short_link!

    @short_link.origin_url
  end

  private

  def validate_domain!
    raise InvalidDomainError, "Invalid domain" unless @url.start_with?(@domain)
  end

  def validate_short_link!
    raise UrlNotFoundError, "URL not found" unless @short_link
  end

  def find_short_link(code)
    @short_link = ShortLink.find_by(code: code)
  end
end
