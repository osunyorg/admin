class AddSlugsToPersonAndOrganizationsCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :university_organization_categories, :slug, :string
    add_column :university_person_categories, :slug, :string

    University::Organization::Category.reset_column_information
    University::Organization::Category.all.find_each do |category|
      category.set_slug
      category.update_column(:slug, category.slug)
    end

    University::Person::Category.reset_column_information
    University::Person::Category.all.find_each do |category|
      category.set_slug
      category.update_column(:slug, category.slug)
    end
  end
end
