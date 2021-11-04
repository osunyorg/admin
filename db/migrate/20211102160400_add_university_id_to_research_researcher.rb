class AddUniversityIdToResearchResearcher < ActiveRecord::Migration[6.1]
  def change
    add_reference :research_researchers,
                  :university,
                  null: true,
                  foreign_key: true,
                  type: :uuid,
                  index: { name: 'idx_researcher_university' }
  end
end
