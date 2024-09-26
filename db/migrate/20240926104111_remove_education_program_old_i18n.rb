class RemoveEducationProgramOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :education_programs, :original_id
    remove_column :education_programs, :language_id
    remove_column :education_programs, :accessibility
    remove_column :education_programs, :contacts
    remove_column :education_programs, :content
    remove_column :education_programs, :duration
    remove_column :education_programs, :evaluation
    remove_column :education_programs, :featured_image_alt
    remove_column :education_programs, :featured_image_credit
    remove_column :education_programs, :meta_description
    remove_column :education_programs, :name
    remove_column :education_programs, :objectives
    remove_column :education_programs, :opportunities
    remove_column :education_programs, :other
    remove_column :education_programs, :path
    remove_column :education_programs, :pedagogy
    remove_column :education_programs, :prerequisites
    remove_column :education_programs, :presentation
    remove_column :education_programs, :pricing
    remove_column :education_programs, :pricing_apprenticeship
    remove_column :education_programs, :pricing_continuing
    remove_column :education_programs, :pricing_initial
    remove_column :education_programs, :published
    remove_column :education_programs, :qualiopi_text
    remove_column :education_programs, :registration
    remove_column :education_programs, :registration_url
    remove_column :education_programs, :results
    remove_column :education_programs, :short_name
    remove_column :education_programs, :slug
    remove_column :education_programs, :summary
    remove_column :education_programs, :url

  end
end
