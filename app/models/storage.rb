class Storage < ApplicationRecord
  has_many :movements

  validates :name, presence: true, length: { maximum: 20 }
end
