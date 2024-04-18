class AddMissingLanguages < ActiveRecord::Migration[7.1]
  def change
    # Ajout des clés
    add_reference :administration_locations, :language, foreign_key: true, type: :uuid
    add_reference :administration_locations, :original, foreign_key: {to_table: :administration_locations}, type: :uuid
    add_reference :education_programs, :language, foreign_key: true, type: :uuid
    add_reference :education_programs, :original, foreign_key: {to_table: :education_programs}, type: :uuid
    add_reference :education_diplomas, :language, foreign_key: true, type: :uuid
    add_reference :education_diplomas, :original, foreign_key: {to_table: :education_diplomas}, type: :uuid
    add_reference :research_journal_papers, :language, foreign_key: true, type: :uuid
    add_reference :research_journal_papers, :original, foreign_key: {to_table: :research_journal_papers}, type: :uuid
    add_reference :research_journal_paper_kinds, :language, foreign_key: true, type: :uuid
    add_reference :research_journal_paper_kinds, :original, foreign_key: {to_table: :research_journal_paper_kinds}, type: :uuid
    add_reference :research_journal_volumes, :language, foreign_key: true, type: :uuid
    add_reference :research_journal_volumes, :original, foreign_key: {to_table: :research_journal_volumes}, type: :uuid
    # Initialisation des langues
    Administration::Location.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    Education::Program.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    Education::Diploma.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    Research::Journal::Paper.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    Research::Journal::Paper::Kind.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    Research::Journal::Volume.find_each { |object| object.update_column(:language_id, object.university.default_language_id) }
    # Verrouillage des clés
    change_column_null :administration_locations, :language_id, false
    change_column_null :education_programs, :language_id, false
    change_column_null :education_diplomas, :language_id, false
    change_column_null :research_journal_papers, :language_id, false
    change_column_null :research_journal_paper_kinds, :language_id, false
    change_column_null :research_journal_volumes, :language_id, false
  end
end
