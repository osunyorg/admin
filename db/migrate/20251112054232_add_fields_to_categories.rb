class AddFieldsToCategories < ActiveRecord::Migration[8.0]
  def change
    [
      :communication_website_agenda_category_localizations,
      :communication_website_jobboard_category_localizations,
      :communication_website_page_category_localizations,
      :communication_website_portfolio_category_localizations,
      :communication_website_post_category_localizations,
      :education_program_category_localizations,
      :university_organization_category_localizations,
      :university_person_category_localizations,
    ].each do |table|
      add_column table, :subtitle, :string
      add_column table, :breadcrumb_title, :string
      add_column table, :header_cta, :boolean, default: false
      add_column table, :header_cta_label, :string
      add_column table, :header_cta_url, :string
      add_column table, :header_text, :text
    end
  end
end
