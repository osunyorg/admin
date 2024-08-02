class AddI18nInfosToInvolvements < ActiveRecord::Migration[7.1]
  def up
    add_reference :university_person_involvements, :language, foreign_key: true, type: :uuid
    add_reference :university_person_involvements, :original, foreign_key: {to_table: :university_person_involvements}, type: :uuid

    University::Person::Involvement.reset_column_information
    University::Person::Involvement.all.find_each do |involvement|
      if involvement.target_type == 'Research::Laboratory'
        # atm laboratory has no language
        language_id = involvement.user.language_id
      else
        language_id = involvement.target.language_id
      end
      involvement.update_column(:language_id, language_id)
    end
  end

  def down
    remove_reference :university_person_involvements, :original
    remove_reference :university_person_involvements, :language
  end
end
