class RemoveEducationProgramOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :education_programs, :original_id
    remove_colum :education_programs, :language_id
    remove_colum :education_programs, :accessibility
    remove_colum :education_programs, :contacts
    remove_colum :education_programs, :content
    remove_colum :education_programs, :duration
    remove_colum :education_programs, :evaluation
    remove_colum :education_programs, :featured_image_alt
    remove_colum :education_programs, :featured_image_credit
    remove_colum :education_programs, :meta_description
    remove_colum :education_programs, :name
    remove_colum :education_programs, :objectives
    remove_colum :education_programs, :opportunities
    remove_colum :education_programs, :other
    remove_colum :education_programs, :path
    remove_colum :education_programs, :pedagogy
    remove_colum :education_programs, :prerequisites
    remove_colum :education_programs, :presentation
    remove_colum :education_programs, :pricing
    remove_colum :education_programs, :pricing_apprenticeship
    remove_colum :education_programs, :pricing_continuing
    remove_colum :education_programs, :pricing_initial
    remove_colum :education_programs, :published
    remove_colum :education_programs, :qualiopi_text
    remove_colum :education_programs, :registration
    remove_colum :education_programs, :registration_url
    remove_colum :education_programs, :results
    remove_colum :education_programs, :short_name
    remove_colum :education_programs, :slug
    remove_colum :education_programs, :summary
    remove_colum :education_programs, :url
    
  end
end
