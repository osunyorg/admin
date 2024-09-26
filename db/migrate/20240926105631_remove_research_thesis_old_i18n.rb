class RemoveResearchThesisOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_theses, :abstract
    remove_column :research_theses, :title

  end
end
