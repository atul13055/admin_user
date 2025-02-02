class AdminUser < ApplicationRecord
  devise :database_authenticatable, 
         :rememberable, :validatable, :lockable, :timeoutable, :trackable

  enum role: { admin: 1 }, _default: :admin # Only admin role for AdminUser

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", 
     "failed_attempts", "id", "id_value", "last_sign_in_at", "last_sign_in_ip", 
     "locked_at", "remember_created_at", "sign_in_count", "updated_at"]
  end
end
