class CreateCommunicationWebsitePortfolioProjectLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_portfolio_projects, :language_id, true

    create_table :communication_website_portfolio_project_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_portfolio_projects }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Portfolio::Project.find_each do |project|
      puts "Migration project #{project.id}"

      about_id = project.original_id || project.id

      l10n = Communication::Website::Portfolio::Project::Localization.create(
        featured_image_alt: project.featured_image_alt,
        featured_image_credit: project.featured_image_credit,
        meta_description: project.meta_description,
        published: project.published,
        published_at: project.updated_at, # No published_at yet
        slug: project.slug,
        summary: project.summary,
        title: project.title,
        about_id: about_id,

        language_id: project.language_id,
        communication_website_id: project.communication_website_id,
        university_id: project.university_id,
        created_at: project.created_at
      )

      project.translate_contents!(l10n)
      project.translate_attachment(l10n, :featured_image)
      project.translate_other_attachments(l10n)

      project.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :communication_website_portfolio_project_localizations
  end
end
