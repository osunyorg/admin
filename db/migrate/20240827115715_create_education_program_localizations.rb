class CreateEducationProgramLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :education_programs, :language_id, true

    create_table :education_program_localizations, id: :uuid do |t|
      t.text :accessibility
      t.text :contacts
      t.text :content
      t.string :duration
      t.text :evaluation
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :name
      t.text :objectives
      t.text :opportunities
      t.text :other
      t.string :path
      t.text :pedagogy
      t.text :prerequisites
      t.text :presentation
      t.text :pricing
      t.text :pricing_apprenticeship
      t.text :pricing_continuing
      t.text :pricing_initial
      t.boolean :published, default: false
      t.datetime :published_at
      t.text :qualiopi_text
      t.text :registration
      t.string :registration_url
      t.text :results
      t.string :short_name
      t.string :slug
      t.text :summary
      t.string :url

      t.references :about, foreign_key: { to_table: :education_programs }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :education_program_localizations
  end
end
