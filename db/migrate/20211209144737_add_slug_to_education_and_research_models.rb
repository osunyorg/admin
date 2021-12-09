class AddSlugToEducationAndResearchModels < ActiveRecord::Migration[6.1]
  def change
    add_column :education_programs, :slug, :string
    add_column :research_journal_articles, :slug, :string
    add_column :research_journal_volumes, :slug, :string
    add_column :research_researchers, :slug, :string
  end
end
