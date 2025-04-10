class ShortLinkGeneratorService < ApplicationService
  def initialize(url)
    @url = url
    @max_retries = ENV.fetch("MAX_SHORTLINK_RETRIES", 3).to_i
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

  def create_short_link(short_code, attempts = @max_retries)
    ShortLink.create!(origin_url: @url, code: short_code)
  rescue ActiveRecord::RecordNotUnique # Add retries if not unique
    raise if attempts <= 0

    Rails.logger.warn("Short code collision, retrying... (attempts left: #{attempts - 1})")
    new_code = build_short_code(CounterManagerService.call)
    create_short_link(new_code, attempts - 1)
  end
end
