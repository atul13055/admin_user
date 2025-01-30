# class ApplicationRecord < ActiveRecord::Base
#   primary_abstract_class
#   def self.ransackable_attributes(auth_object = nil)
#     ["created_at", "description", "id", "id_value", "name", "updated_at"]
#   end
# end
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map(&:name).map(&:to_s) # Sabhi associations allowlist honge
  end

  def self.ransackable_attributes(auth_object = nil)
    column_names # Sabhi database columns allow honge
  end
end
