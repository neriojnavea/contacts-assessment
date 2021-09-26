class Import < ApplicationRecord
  ON_HOLD = 'on hold'
  PROCESSING = 'processing'
  FAILED = 'failed'
  TERMINATED = 'terminated'

  validates :file, presence: true

  belongs_to :user
  has_one_attached :file
end
