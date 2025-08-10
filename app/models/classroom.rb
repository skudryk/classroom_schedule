class Classroom < ApplicationRecord
  has_many :sections, dependent: :destroy
  
  validates :name, presence: true
  validates :building, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :room_number, presence: true
end
