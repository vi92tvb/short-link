class ShortLinkGeneratorService < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    total_codes = CounterManagerService.call
    short_code = build_short_code(total_codes)
    create_short_link(short_code)
    short_code
  end

  private

  def build_short_code(total_codes)
    max_value = 62**total_codes
    timestamp = Time.now.to_i
    hash = Digest::SHA256.hexdigest("#{@url}#{timestamp}").to_i(16) % max_value
    hash.base62_encode
  end

  def create_short_link(short_code)
    ShortLink.create!(origin_url: @url, code: short_code)
  rescue => e
    Rails.logger.error("Failed to create short link: #{e.message}")
    raise
  end
end
