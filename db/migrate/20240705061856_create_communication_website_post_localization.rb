class CreateCommunicationWebsitePostLocalization < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_posts, :language_id, true
    create_table :communication_website_post_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :migration_identifier
      t.boolean :pinned
      t.boolean :published
      t.datetime :published_at
      t.string  :slug
      t.text    :summary
      t.text :text
      t.string  :title

      t.references :about, foreign_key: { to_table: :communication_website_posts }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Post.find_each do |post|
      puts "Migration post #{post.id}"

      about_id = post.original_id || post.id

      l10n = Communication::Website::Post::Localization.create(
        featured_image_alt: post.featured_image_alt,
        featured_image_credit: post.featured_image_credit,
        meta_description: post.meta_description,
        migration_identifier: post.migration_identifier,
        pinned: post.pinned,
        published: post.published,
        published_at: post.published_at,
        slug: post.slug,
        summary: post.summary,
        text: post.text,
        title: post.title,
        about_id: about_id,
        language_id: post.language_id,
        communication_website_id: post.communication_website_id,
        university_id: post.university_id,
        created_at: post.created_at
      )

      post.translate_contents!(l10n)
      post.translate_attachment(l10n, :featured_image)
      post.translate_other_attachments(l10n)

      post.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :communication_website_post_localizations
  end
end