ActiveAdmin.register Package do
  permit_params :name, :description, pricings_attributes: [:id, :country, :price, :_destroy]

  
  index do
    selectable_column
    id_column
    column :name
    column :description do |package|
     package.description.html_safe
    end
    column "Pricing Details" do |package|
      package.pricings.each_with_index.map do |p, index|
        country = ISO3166::Country[p.country]
        flag = country&.emoji_flag || "🏳️"
        "#{index + 1}. #{flag} #{country.translations['en']} - #{country.currency_code}:- #{p.price}"
      end.join("<br>").html_safe 
    end

    actions
  end

  form do |f|
    f.inputs "Package Details" do
      f.input :name
      f.input :description, as: :quill_editor
    end

    f.has_many :pricings, heading: "Pricing Details", allow_destroy: true, new_record: true do |p|
      p.input :country, 
              as: :select, 
              collection: ISO3166::Country.all.map { |c| ["#{c.emoji_flag} #{c.translations['en']}", c.alpha2] }, 
              include_blank: false, 
              prompt: "Select Country"
      p.input :price
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description do |package|
        package.description.html_safe
      end
    end

    panel "Pricing Details" do
      table_for package.pricings do
        column "Country" do |p|
          country = ISO3166::Country[p.country]
          flag = country&.emoji_flag || "🏳️"
          "#{flag} #{country.translations['en']}".html_safe
        end
        column :price
      end
    end
  end
end
