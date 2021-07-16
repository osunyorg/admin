class CreateQualiopiCriterions < ActiveRecord::Migration[6.1]
  def change
    create_table :qualiopi_criterions, id: :uuid do |t|
      t.integer :number
      t.text :name
      t.text :description

      t.timestamps
    end
  end
end
