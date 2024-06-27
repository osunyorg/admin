class AddI18nInfosToRoles < ActiveRecord::Migration[7.1]
  def up
    add_reference :university_roles, :language, foreign_key: true, type: :uuid
    add_reference :university_roles, :original, foreign_key: {to_table: :university_roles}, type: :uuid

    University::Role.reset_column_information
    University::Role.all.each do |role|
      role.update(language_id: role.target.language_id)
    end
  end

  def down
    remove_reference :university_roles, :original
    remove_reference :university_roles, :language
  end
end
