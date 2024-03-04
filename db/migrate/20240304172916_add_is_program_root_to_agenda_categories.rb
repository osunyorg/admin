class AddIsProgramRootToAgendaCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_categories, :is_programs_root, :boolean, default: false
    add_reference :communication_website_agenda_categories, :program, foreign_key: {to_table: :education_programs}, type: :uuid
  end
end
