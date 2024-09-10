class Migrations::L10n::Communication::Website::Portfolio::Project < Migrations::L10n::Base
  def self.execute
    Communication::Website::Portfolio::Project.where(self.constraint).find_each do |project|
      puts "Migration project #{project.id}"

      about_id = project.original_id || project.id
      next if Communication::Website::Portfolio::Project::Localization.where(
        about_id: about_id,
        language_id: project.language_id
      ).exists?

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

      duplicate_permalinks(project, l10n)
      reconnect_git_files(project, l10n)

      l10n.save
    end
  end
end