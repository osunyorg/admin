module Communication::Block::WithCommunicationMedias
  extend ActiveSupport::Concern

  included do
    after_create :check_if_all_media_are_localized
    after_save :manage_media_contexts
    after_destroy :destroy_media_contexts
  end

  def destroy_media_contexts
    communication_media_contexts.delete_all
  end

  def restore_media_contexts
    communication_medias.each do |media|
      media.add_context(self)
    end
  end

  protected

  def check_if_all_media_are_localized
    communication_medias.each do |media|
      media.create_localization_if_missing!(language)
    end
  end

  def manage_media_contexts
    communication_medias.each do |media|
      context = media.add_context(self)
      crop_settings = crop_settings_for(media)
      next if crop_settings.nil?
      context.apply_crop_settings!(crop_settings)
    end
    destroy_obsolete_media_contexts
  end

  def crop_settings_for(media)
    template.crop_settings_for(media)
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
    Communication::Media::Context.where(
      university: university_id,
      about: self
    )
  end
end
