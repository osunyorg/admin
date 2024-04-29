class AddLanguageToResearchJournal < ActiveRecord::Migration[7.1]
  def change
    # Add language
    add_reference :research_journals, :language, foreign_key: true, type: :uuid

    # Set defaults
    Research::Journal.find_each do |journal|
      journal.update_column :language_id, journal.university.default_language_id
    end

    begin
      # Manage Degrowth journal
      degrowth = Research::Journal.find('366dc003-e801-4967-a367-bc1eb87b683b')
      english = Language.find_by(iso_code: 'en')
      degrowth.update_column :language_id, english.id
    rescue
    end
    
    # Make language mandatory
    change_column_null :research_journals, :language_id, false
  end
end
