class User < ApplicationRecord
  belongs_to :package

  # Devise handles authentication and validation for email and password
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  attr_accessor :update_password

  # Only validate password presence if the update_password checkbox is checked
  validates :password, presence: true, if: :update_password?

  def update_password?
    update_password == '1' # This checks if the checkbox is checked
  end

  # Enum for user role (member by default)
  enum role: { member: 0 }, _default: :member

  # Custom validations for mobile number
  validates :mobile, presence: true

  # Validations for other fields (age, height, weight)
  validates :age, numericality: { greater_than_or_equal_to: 18, less_than_or_equal_to: 100 }, allow_nil: true
  validates :height, :weight, numericality: true, allow_nil: true

  # Name validation (required)
  validates :name, presence: true

  # Optional custom validation for state and city (if applicable)
  # validate :valid_state_city_for_country
  validate :validate_mobile_format

  def validate_mobile_format
    parsed_number = Phonelib.parse(mobile)
    if parsed_number.valid?
      self.mobile = parsed_number.e164  # Store the phone number in E.164 format
    else
      errors.add(:mobile, "Invalid phone number")  # Add an error if invalid
    end
  end
  private

  # Optional custom validation logic for state and city
  def valid_state_city_for_country
    return unless country.present? && state.present? && city.present?
  end
end
