ActiveAdmin.register User, as: "Members" do
  permit_params :name, :email, :mobile, :country, :state, :city, :other_city,
                :profession, :age, :sex, :height, :weight, :role, :package_id, 
                :password, :password_confirmation, :status, :update_password
actions :all, :except => :destroy
  # Filters for easy search
  filter :name
  filter :email
  filter :mobile
  filter :country
  filter :state
  filter :city
  

  # Index page - Table view
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :mobile
    column "Country" do |p|
      country = ISO3166::Country[p.country]
      flag = country&.emoji_flag || "🏳️"
      country_name = country ? country.translations['en'] : 'Unknown Country'
      "#{flag} #{country_name}".html_safe
    end
    column :state do |user|
        selected_state_name = CS.states(user.country)[user.state.to_sym]
    end
    column :city
    column :profession
    column :age
    column :sex
    column :height
    column :weight
    column :role
    column :status do |user|
      user.status ? 'Active' : 'Inactive'  # Display "Active" or "Inactive"
    end
    column :package
    column :created_at
    actions
  end

  # Show page - Detailed view
  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :mobile
      row "Country" do |p|
        country = ISO3166::Country[p.country]
        flag = country&.emoji_flag || "🏳️"
        country_name = country ? country.translations['en'] : 'Unknown Country'
        "#{flag} #{country_name}".html_safe
      end
      row :state do |user|
          selected_state_name = CS.states(user.country)[user.state.to_sym]
      end
      row :city
      row :other_city
      row :profession
      row :age
      row :sex
      row :height
      row :weight
      row :role
      row :status do |user|
        user.status ? 'Active' : 'Inactive'  # Display "Active" or "Inactive"
      end
      row :package
      row :created_at
      row :updated_at
    end
  end

  # Form for new/edit pages
  form do |f|
    f.inputs "User Details" do
      f.input :name, required: true

      if f.object.new_record?
        f.input :email, required: true
      else
        f.input :email, input_html: { readonly: true }, required: true
      end

      f.input :mobile, as: :string, input_html: { 
        id: "phone", 
        class: "form-control", 
        placeholder: "+91 8123456789", 
        readonly: !f.object.new_record? 
      }

      # Country and state select inputs, if applicable
      f.input :country, 
              as: :select, 
              collection: ISO3166::Country.all.map { |c| ["#{c.emoji_flag} #{c.translations['en']}", c.alpha2] }, 
              include_blank: false, 
              prompt: "Select Country", 
              selected: f.object.country, 
              input_html: { id: "user_country", onchange: "updateStatesAndCities(this.value)" }

      f.input :state, 
              as: :select, 
              collection: CS.states(f.object.country).map { |code, name| [name, code] }, 
              include_blank: false, 
              prompt: "Select State", 
              selected: f.object.state, 
              input_html: { id: "user_state", class: 'state-select', onchange: "updateCities(this.value, '#{f.object.country}')" }

      f.input :city, 
              as: :select, 
              collection: (CS.cities(f.object.state, f.object.country) || []).map { |city| [city, city] } + [['Other', 'Other']],
              include_blank: false, 
              prompt: "Select City", 
              selected: f.object.city, 
              input_html: { id: "user_city", class: 'city-select', onchange: "toggleOtherCityField()" }

      f.input :other_city, label: "Other City", input_html: { id: "user_other_city", class: 'form-control d-none', disabled: true }

      f.input :profession, required: true
      f.input :age, required: true
      f.input :sex, as: :select, collection: ['Male', 'Female', 'Other'], include_blank: false, required: true
      f.input :height, required: true
      f.input :weight, required: true
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false, required: true
      f.input :status, as: :select, collection: [['Active', true], ['Inactive', false]], include_blank: false, required: true
      f.input :package, as: :select, collection: Package.all.map { |p| [p.name, p.id] }, include_blank: false, required: true

      if f.object.new_record?
        f.input :password, label: "Password", input_html: { class: 'password-field'}, required: true
        f.input :password_confirmation, label: "Confirm Password", input_html: { class: 'password-field' }, required: true
      else
        f.input :update_password, as: :boolean, label: "Update Password?"
        if f.object.update_password?
          f.input :password, label: "Password", input_html: { class: 'password-field' }, required: true
          f.input :password_confirmation, label: "Confirm Password", input_html: { class: 'password-field' }, required: true
        end
      end
    end
    f.actions
  end

end

