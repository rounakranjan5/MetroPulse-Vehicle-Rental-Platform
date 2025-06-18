class Payment < ApplicationRecord
  belongs_to :booking

  validates :amount, :status,presence: true
end
