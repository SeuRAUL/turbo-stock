class Movement < ApplicationRecord
  belongs_to :storage
  belongs_to :product

  validates_associated :storage
  validates_associated :product

  validates :movement_type, inclusion: { in: %w(E S) }
  validates :date, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
