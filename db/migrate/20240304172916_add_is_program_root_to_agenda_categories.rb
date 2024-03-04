class AddIsProgramRootToAgendaCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_categories, :is_programs_root, :boolean, default: false
  end
end
