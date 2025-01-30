class User < ApplicationRecord
  belongs_to :package

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { greater_than_or_equal_to: 18, less_than_or_equal_to: 100 }, allow_nil: true
  validates :height, :weight, numericality: true, allow_nil: true
end
