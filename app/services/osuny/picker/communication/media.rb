class Osuny::Picker::Communication::Media < Osuny::Picker

  def objects
    @objects ||= university.communication_medias
  end

  def categories
    @categories ||= university.communication_media_categories
  end

end