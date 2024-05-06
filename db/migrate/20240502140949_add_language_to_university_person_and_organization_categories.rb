class AddLanguageToUniversityPersonAndOrganizationCategories < ActiveRecord::Migration[7.1]
  def change
    # Add language
    add_reference :university_organization_categories, :language, foreign_key: true, type: :uuid
    add_reference :university_organization_categories, :original, foreign_key: {to_table: :university_organization_categories}, type: :uuid
    add_reference :university_person_categories, :language, foreign_key: true, type: :uuid
    add_reference :university_person_categories, :original, foreign_key: {to_table: :university_person_categories}, type: :uuid

    # Set defaults
    University::Organization::Category.reset_column_information
    University::Organization::Category.find_each do |category|
      category.update_column :language_id, category.university.default_language_id
    end
    University::Person::Category.reset_column_information
    University::Person::Category.find_each do |category|
      category.update_column :language_id, category.university.default_language_id
    end

    # Create translations when needed
    # We loop through all categories in the university default language
    University::Organization::Category.joins(:university).where("university_organization_categories.language_id = universities.default_language_id").find_each do |category|
      # Find all languages that are not the default language from category's organizations
      languages = Language.where(id: category.organizations.where.not(language_id: category.language_id).distinct.pluck(:language_id))
      languages.each do |language|
        # Find or create translation
        translation = category.find_or_translate!(language)
        # For each organization in the category with this language, remove the master category and add the translation
        category.organizations.where(language_id: language.id).each do |organization|
          organization.categories.delete(category)
          organization.categories << translation
        end
      end
    end

    # Create translations when needed
    # We loop through all categories in the university default language
    University::Person::Category.joins(:university).where("university_person_categories.language_id = universities.default_language_id").find_each do |category|
      # Find all languages that are not the default language from category's people
      languages = Language.where(id: category.people.where.not(language_id: category.language_id).distinct.pluck(:language_id))
      languages.each do |language|
        # Find or create translation
        translation = category.find_or_translate!(language)
        # For each organization in the category with this language, remove the master category and add the translation
        category.people.where(language_id: language.id).each do |person|
          person.categories.delete(category)
          person.categories << translation
        end
      end
    end

    # Make language mandatory
    change_column_null :university_organization_categories, :language_id, false
    change_column_null :university_person_categories, :language_id, false
  end
end
