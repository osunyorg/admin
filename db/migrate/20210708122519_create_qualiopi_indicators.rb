class CreateQualiopiIndicators < ActiveRecord::Migration[6.1]
  def change
    create_table :qualiopi_indicators, id: :uuid do |t|
      t.references :criterion, null: false, foreign_key: {to_table: :qualiopi_criterions}, type: :uuid
      t.integer :number
      t.text :name
      t.text :level_expected
      t.text :proof
      t.text :requirement
      t.text :non_conformity

      t.timestamps
    end
  end
end
