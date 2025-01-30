class AdminUser < ApplicationRecord
  # Include default devise modules except email sending ones
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, :timeoutable, :trackable

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", 
     "failed_attempts", "id", "id_value", "last_sign_in_at", "last_sign_in_ip", 
     "locked_at", "remember_created_at", "sign_in_count", "updated_at"]
  end
end
