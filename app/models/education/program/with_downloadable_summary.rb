module Education::Program::WithDownloadableSummary
  extend ActiveSupport::Concern

  included do
    belongs_to :downloadable_summary,
              class_name: 'Communication::File',
              optional: true

    after_destroy :destroy_downloadable_summary_context
    after_restore :restore_downloadable_summary_context
  end

  # Cf HasFeaturedMedia#set_featured_media!, qui fait la même chose pour les médias.
  def set_downloadable_summary!(id: '', language:)
    if id.present?
      file = university.communication_files.find(id)
      file_l10n = file.create_localization_if_missing!(language)
      context = file_l10n.add_context(self)
    end
    self.downloadable_summary = file
    save!
    Communication::File::Context.remove(self, except: context)
    file
  end

  def communication_file_contexts
    Communication::File::Context.where(
      about: self,
      university_id: university_id
    )
  end

  protected

  def destroy_downloadable_summary_context
    communication_file_contexts.destroy_all
  end

  def restore_downloadable_summary_context
    return if downloadable_summary.nil?
    # Les contextes attachent le program (pas sa loca) aux localisation des fichiers 
    localizations.each do |l10n|
      downloadable_summary_l10n = downloadable_summary.best_localization_for(l10n.language)
      downloadable_summary_l10n.add_context(self)
    end
  end
end
