class AddProgramToCommunicationWebsiteCategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_categories, :program, foreign_key: { to_table: :education_programs }, type: :uuid
  end
end
