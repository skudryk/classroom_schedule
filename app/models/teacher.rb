class Teacher < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :subjects, through: :sections
  belongs_to :account, as: :user

  delegate :email, :name, :address to: :account

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :department, presence: true
end
