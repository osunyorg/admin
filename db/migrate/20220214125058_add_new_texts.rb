class AddNewTexts < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_homes, :text_new, :text
    add_column :communication_website_pages, :text_new, :text
    add_column :research_journal_articles, :text_new, :text
    add_column :research_laboratory_axes, :text_new, :text
    add_column :university_people, :biography_new, :text
    add_column :education_programs, :accessibility_new, :text
    add_column :education_programs, :contacts_new, :text
    add_column :education_programs, :duration_new, :text
    add_column :education_programs, :evaluation_new, :text
    add_column :education_programs, :objectives_new, :text
    add_column :education_programs, :opportunities_new, :text
    add_column :education_programs, :other_new, :text
    add_column :education_programs, :pedagogy_new, :text
    add_column :education_programs, :prerequisites_new, :text
    add_column :education_programs, :pricing_new, :text
    add_column :education_programs, :registration_new, :text
    add_column :education_programs, :content_new, :text
    add_column :education_programs, :results_new, :text
    # Clean an old field
    remove_column :research_journal_articles, :old_text
  end
end
