class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :sections, through: :enrollments
  
  belongs_to :account, as: :user

  delegate :email, :name, :address to: :account

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :year, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
end
