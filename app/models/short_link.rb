class ShortLink < ApplicationRecord
  validates :code, uniqueness: true
end
