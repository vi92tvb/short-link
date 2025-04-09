class CounterManagerService < ApplicationService
  MIN_TOKEN_LENGTH = 6

  def initialize
    @counter = Counter.find_or_create_by(name: "total_codes")
  end

  def call
    total_codes = @counter.count.to_i
    @counter.update!(count: total_codes + 1)
    calculate_token_size(total_codes)
  rescue => e
    Rails.logger.error("Failed to update the counter: #{e.message}")
    raise
  end

  private

  def calculate_token_size(total_codes)
    # Calculate shortcode length using base 62 logarithm
    token_size = (Math.log(total_codes + 1) / Math.log(62)).ceil
    [ token_size, MIN_TOKEN_LENGTH ].max
  end
end
