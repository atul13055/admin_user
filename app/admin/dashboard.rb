ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Super Admin Dashboard"

  content title: "Super Admin Dashboard" do
    div class: "dashboard-links" do
      link_to "Add Package", admin_packages_path, class: "button"
    end
  end
end
