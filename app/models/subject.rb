class Subject < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teachers, through: :sections
  
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :credits, presence: true, numericality: { greater_than: 0 }
end
