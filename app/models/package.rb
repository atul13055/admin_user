class Package < ApplicationRecord
  has_many :pricings, dependent: :destroy
  accepts_nested_attributes_for :pricings, allow_destroy: true
end
