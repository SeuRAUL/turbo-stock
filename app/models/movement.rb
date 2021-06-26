class Movement < ApplicationRecord
  belongs_to :storage
  belongs_to :product

  validates_associated :storages
  validates_associated :products

  validates :type, inclusion: { in: %w(E S) }
  validates :date, presence: true
  validates :quantity, presence: true, minimum: 1

end
