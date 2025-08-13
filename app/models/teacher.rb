class Teacher < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :subjects, through: :sections

  has_one :account, as: :user

  delegate :email, :name, :address,  to: :account
  accepts_nested_attributes_for :account, allow_destroy: true

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :department, presence: true
end
