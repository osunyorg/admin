class AddIndexesToSlugs < ActiveRecord::Migration[7.0]
  def change
    add_index :communication_block_headings, :slug
    add_index :communication_extranet_document_categories, :slug
    add_index :communication_extranet_document_kinds, :slug
    add_index :communication_extranet_post_categories, :slug
    add_index :communication_extranet_posts, :slug
    add_index :communication_website_agenda_events, :slug
    add_index :communication_website_categories, :slug
    add_index :communication_website_pages, :slug
    add_index :communication_website_posts, :slug
    add_index :education_diplomas, :slug
    add_index :education_programs, :slug
    add_index :research_hal_publications, :slug
    add_index :research_journal_paper_kinds, :slug
    add_index :research_journal_papers, :slug
    add_index :research_journal_volumes, :slug
    add_index :university_organizations, :slug
    add_index :university_people, :slug
  end
end
