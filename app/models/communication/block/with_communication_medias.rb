module Communication::Block::WithCommunicationMedias
  extend ActiveSupport::Concern

  included do
    after_create :check_if_all_media_are_localized
    after_save :manage_media_contexts
  end

  protected

  def check_if_all_media_are_localized
    communication_medias.each do |media|
      media.create_localization_if_missing!(language)
    end
  end

  def manage_media_contexts
    communication_medias.each do |media|
      context = media.context_add(self)
      crop_settings = crop_settings_for(media)
      context.apply_crop_settings!(crop_settings)
    end
    destroy_obsolete_media_contexts
  end

  def crop_settings_for(media)
    byebug
    # Trouver dans les data les crop_settings qui correspondent
  end

  def first_or_create_media_context_for(media)
    communication_media_contexts.where(
      communication_media_id: media.id
    ).first_or_create!
  end

  def destroy_obsolete_media_contexts
    communication_media_contexts.where.not(
      communication_media_id: commmunication_media_ids
    ).destroy_all
  end

  def communication_medias
    template.communication_medias
  end

  def commmunication_media_ids
    communication_medias.map(&:id)
  end

  def communication_media_contexts
    Communication::Media::Context.where(university: university_id, about: self)
  end
end
