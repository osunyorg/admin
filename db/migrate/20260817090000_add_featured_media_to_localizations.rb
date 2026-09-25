class AddFeaturedMediaToLocalizations < ActiveRecord::Migration[8.1]
  TABLES = [
    :administration_location_localizations,
    :communication_extranet_post_localizations,
    :communication_file_category_localizations,
    :communication_file_localizations,
    :communication_media_category_localizations,
    :communication_media_collection_localizations,
    :communication_website_agenda_category_localizations,
    :communication_website_agenda_event_localizations,
    :communication_website_agenda_exhibition_localizations,
    :communication_website_jobboard_category_localizations,
    :communication_website_jobboard_job_localizations,
    :communication_website_page_category_localizations,
    :communication_website_page_localizations,
    :communication_website_portfolio_category_localizations,
    :communication_website_portfolio_project_localizations,
    :communication_website_post_category_localizations,
    :communication_website_post_localizations,
    :education_program_category_localizations,
    :education_program_localizations,
    :research_journal_volume_localizations,
    :university_organization_category_localizations,
    :university_organization_localizations,
    :university_person_category_localizations,
    :university_person_localizations,
  ]

  def change
    TABLES.each do |table|
      add_reference table,
                    :featured_media,
                    type: :uuid,
                    foreign_key: {
                      to_table: :communication_medias,
                      on_delete: :nullify
                    }
      rename_column table, :featured_image_alt, :featured_media_alt
    end
  end
end
