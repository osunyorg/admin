module HasFeaturedMedia
  extend ActiveSupport::Concern

  included do
    attr_accessor :featured_media_new_url

    belongs_to  :featured_media,
                class_name: 'Communication::Media',
                optional: true

    after_commit :create_featured_media_from_url_later, on: [:create, :update]
  end

  def featured_blob
     # FIXME[files] original_blob ou blob? Gestion de la publication
    featured_media&.original_blob
  end

  def featured_media_localization
    return if featured_media.nil?
    featured_media.best_localization_for(language)
  end

  def set_featured_media!(id: '', alt: '', language:, crop_settings: {})
    # On récupère le média, qui peut être une absence de média.
    # Si l'id est vide, le media sera nil, et on réinitialise proprement.
    if id.present?
      media = university.communication_medias.find(id)
      media.find_or_create_localization(language)
      context = media.context_add(self)
      context.apply_crop_settings!(crop_settings)
    end
    Communication::Media::Context.remove(self, except: context)
    self.featured_media = media
    self.featured_media_alt = alt
    save
    media
  end

  # Gestion des héritages, à ranger (méthodes best_*)
  # A priori c'est nécessaire uniquement pour les formations (Program), mais il faut vérifier.
  # Si ça se vérifie, il faut les sortir du concern et les mettre dans Program.
  def best_featured_media_source(fallback: true)
    self
  end

  def best_featured_media
    best_featured_media_source.featured_media
  end

  def best_featured_media_alt
    best_featured_media_source.featured_media_alt
  end

  def best_featured_media_credit
    best_featured_media_source.featured_media_credit
  end

  # Credit is not localized on the object, it belongs to the media itself
  def featured_media_credit
    featured_media_localization&.credit
  end

  def best_featured_blob
    best_featured_media&.original_blob
  end


  protected

  def create_featured_media_from_url_later
    # No image to upload
    return unless featured_media_new_url.present?
    # Image already uploaded
    return if featured_blob&.metadata&.dig(:source_url) == featured_media_new_url
    # Else, delay the upload
    Api::CreateFeaturedMediaFromUrlJob.perform_later(self, featured_media_new_url)
  ensure
    self.featured_media_new_url = nil
  end
end
