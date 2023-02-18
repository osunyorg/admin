class RemoveHalFromResearchers < ActiveRecord::Migration[7.0]
  def change
    remove_column :university_people, :hal_person_identifier
    remove_column :university_people, :hal_doc_identifier
    remove_column :university_people, :hal_form_identifier
  end
end
