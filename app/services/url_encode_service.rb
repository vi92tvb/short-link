require 'base62'

class UrlEncodeService < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    generate_short_code(@url)
  end

  private

  def generate_short_code(url)
    short_code = nil
  
    ActiveRecord::Base.transaction do
      counter = Counter.find_or_create_by(name: 'total_codes')
      total_codes = counter.count.to_i
  
      short_code = build_short_code(url, total_codes)
  
      counter.update!(count: total_codes + 1)
      ShortLink.create!(origin_url: url, code: short_code)
    end
  
    short_code
  end

  def build_short_code(url, total_codes)
    token_size = calculate_token_size(total_codes)
    max_value = 62**token_size
    timestamp = Time.now.to_i

    hash = Digest::SHA256.hexdigest("#{url}#{timestamp}").to_i(16) % max_value
    hash.base62_encode
  end

  def calculate_token_size(current_num)
    # Calculate shortcode length using base 62 logarithm
    token_size = (Math.log(current_num + 1) / Math.log(62)).ceil

    # Minimun length is 6 characters
    [token_size, 6].max
  end
end
