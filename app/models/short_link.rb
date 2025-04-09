class ShortLink < ApplicationRecord
  validates :code, uniqueness: true

  validates :origin_url, format: {
    with: URI.regexp(%w[http https]),
    message: "must be a valid URL starting with http:// or https://"
  }
end
