# Always applied to a localization
module LibreTranslatable
  extend ActiveSupport::Concern

  def libre_translatable?
    # Might evolve in the future to allow re-translating from another localization.
    # For now, do not translate originals.
    return false if original?
    original.language.supported_by_libretranslate? &&
      language.supported_by_libretranslate?
  end
end