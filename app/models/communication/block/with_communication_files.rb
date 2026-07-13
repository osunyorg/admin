module Communication::Block::WithCommunicationFiles
  extend ActiveSupport::Concern

  included do
    after_save :manage_file_contexts
  end

  protected

  def manage_file_contexts
    communication_file_localizations.each do |localization|
      first_or_create_file_context_for(localization)
    end
    destroy_obsolete_file_contexts
  end

  def first_or_create_file_context_for(localization)
    communication_file_contexts.where(
      communication_file_localization_id: localization.id
    ).first_or_create!
  end

  def destroy_obsolete_file_contexts
    communication_file_contexts.where.not(
      communication_file_localization_id: commmunication_file_localization_ids
    )
    .destroy_all
  end

  def communication_files
    template.communication_files
  end

  def commmunication_file_ids
    communication_files.map(&:id)
  end

  def communication_file_localizations
    Communication::File::Localization.where(
      university_id: university_id,
      language_id: language.id,
      about_id: commmunication_file_ids
    )
  end

  def commmunication_file_localization_ids
    communication_file_localizations.pluck(:id)
  end

  def communication_file_contexts
    Communication::File::Context
      .where(
        university_id: university_id,
        about_id: self.id,
        about_type: self.class.polymorphic_name
      )
  end
end
