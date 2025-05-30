class AddNilFalseToPositionOnSomeModels < ActiveRecord::Migration[8.0]
  def change
    change_column_null :university_roles, :position, false
    change_column_null :communication_media_categories, :position, false
    change_column_null :communication_website_agenda_categories, :position, false
    change_column_null :communication_website_menu_items, :position, false
    change_column_null :communication_website_page_categories, :position, false
    change_column_null :communication_website_portfolio_categories, :position, false
    change_column_null :communication_website_post_categories, :position, false
    change_column_null :education_diplomas, :position, false
    change_column_null :education_program_categories, :position, false
    change_column_null :research_journal_papers, :position, false
    change_column_null :research_laboratory_axes, :position, false
    change_column_null :university_organization_categories, :position, false
    change_column_null :university_person_categories, :position, false
    change_column_null :university_person_involvements, :position, false
    change_column_null :university_roles, :position, false
  end
end
