class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages, id: :uuid do |t|
      t.string :name
      t.string :iso_code

      t.timestamps
    end
  end
end
