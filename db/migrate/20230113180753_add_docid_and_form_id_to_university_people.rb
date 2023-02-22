class AddDocidAndFormIdToUniversityPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :university_people, :hal_doc_identifier, :string
    add_column :university_people, :hal_form_identifier, :string
  end
end
