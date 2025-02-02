class User < ApplicationRecord
  belongs_to :package

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  attr_accessor :update_password

  # If the password checkbox is ticked, validate the password presence
  validates :password, presence: true, if: :update_password?

  def update_password?
    update_password == '1' # This checks if the checkbox is checked
  end

  # Enum for user role (member by default)
  enum role: { member: 0 }, _default: :member

  # Validations for phone number
  validates :mobile, presence: true
  

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { greater_than_or_equal_to: 18, less_than_or_equal_to: 100 }, allow_nil: true
  validates :height, :weight, numericality: true, allow_nil: true

  #  validates :country, presence: true
  # validates :state, presence: true, if: -> { country.present? }
  # validates :city, presence: true, if: -> { state.present? }

  # You can also add custom validation logic to ensure the state and city exist for the given country
  # validate :valid_state_city_for_country

  private

  def valid_state_city_for_country
    return unless country.present? && state.present? && city.present?
  end
end
