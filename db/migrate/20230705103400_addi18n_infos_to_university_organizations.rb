class Addi18nInfosToUniversityOrganizations < ActiveRecord::Migration[7.0]
  def up
    add_reference :university_organizations, :language, foreign_key: true, type: :uuid
    add_reference :university_organizations, :original, foreign_key: {to_table: :university_organizations}, type: :uuid

    University::Organization.reset_column_information
    University.all.find_each do |university|
      university.organizations.update_all(language_id: university.default_language_id)
    end
  end

  def down
    remove_reference :university_organizations, :language
    remove_reference :university_organizations, :original
  end
end
