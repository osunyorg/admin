class RemoveResearchThesisOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_theses, :abstract
    remove_colum :research_theses, :title

  end
end
