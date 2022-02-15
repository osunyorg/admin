class RenameNewTexts < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_homes, :text_new, :text
    rename_column :communication_website_pages, :text_new, :text
    rename_column :communication_website_posts, :text_new, :text
    rename_column :research_journal_articles, :text_new, :text
    rename_column :research_laboratory_axes, :text_new, :text
    rename_column :university_people, :biography_new, :biography
    rename_column :education_programs, :accessibility_new, :accessibility
    rename_column :education_programs, :contacts_new, :contacts
    rename_column :education_programs, :duration_new, :duration
    rename_column :education_programs, :evaluation_new, :evaluation
    rename_column :education_programs, :objectives_new, :objectives
    rename_column :education_programs, :opportunities_new, :opportunities
    rename_column :education_programs, :other_new, :other
    rename_column :education_programs, :pedagogy_new, :pedagogy
    rename_column :education_programs, :prerequisites_new, :prerequisites
    rename_column :education_programs, :pricing_new, :pricing
    rename_column :education_programs, :registration_new, :registration
    rename_column :education_programs, :content_new, :content
    rename_column :education_programs, :results_new, :results
  end
end
