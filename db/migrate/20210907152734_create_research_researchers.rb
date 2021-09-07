class CreateResearchResearchers < ActiveRecord::Migration[6.1]
  def change
    create_table :research_researchers, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.text :biography
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
