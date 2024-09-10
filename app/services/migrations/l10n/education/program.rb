class Migrations::L10n::Education::Program < Migrations::L10n::Base
  def self.execute
    Education::Program.where(self.constraint).find_each do |program|
      about_id = program.original_id || program.id
      next if Education::Program::Localization.where(
        about_id: about_id,
        language_id: program.language_id
      ).exists?

      l10n = Education::Program::Localization.create(
        accessibility: program.accessibility,
        contacts: program.contacts,
        content: program.content,
        duration: program.duration,
        evaluation: program.evaluation,
        featured_image_alt: program.featured_image_alt,
        featured_image_credit: program.featured_image_credit,
        meta_description: program.meta_description,
        name: program.name,
        objectives: program.objectives,
        opportunities: program.opportunities,
        other: program.other,
        path: program.path,
        pedagogy: program.pedagogy,
        prerequisites: program.prerequisites,
        presentation: program.presentation,
        pricing: program.pricing,
        pricing_apprenticeship: program.pricing_apprenticeship,
        pricing_continuing: program.pricing_continuing,
        pricing_initial: program.pricing_initial,
        published: program.published,
        published_at: program.created_at,
        qualiopi_text: program.qualiopi_text,
        registration: program.registration,
        registration_url: program.registration_url,
        results: program.results,
        short_name: program.short_name,
        slug: program.slug,
        summary: program.summary,
        url: program.url,

        about_id: about_id,
        language_id: program.language_id,
        university_id: program.university_id,
        created_at: program.created_at
      )

      program.translate_contents!(l10n)
      program.translate_attachment(l10n, :featured_image)
      program.translate_attachment(l10n, :shared_image)
      program.translate_attachment(l10n, :downloadable_summary)
      program.translate_attachment(l10n, :logo)

      duplicate_permalinks(program, l10n)
      reconnect_git_files(program, l10n)

      l10n.save

      if program.original_id.nil?
        # This program will still exist as master.

        # We need to make sure the diploma is the original.
        if program.diploma.present?
          diploma_id = program.diploma.original_id || program.diploma.id
          program.update_column(:diploma_id, diploma_id)
        end
      end
    end
  end
end