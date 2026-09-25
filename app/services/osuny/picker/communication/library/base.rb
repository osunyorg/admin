class Osuny::Picker::Communication::Library::Base < Osuny::Picker

  protected

  def accept
    @accept ||= params.dig(:accept) || '*'
  end

  def accept_restricted?
    accept != '*'
  end

  # .mp3, .wav => ['.mp3', '.wav']
  def extensions
    @extensions ||= accept.gsub(', ', ',').split(',')
  end

  def objects_filtered
    super
    accept_restricted?  ? @objects_filtered.for_extension(extensions, language)
                        : @objects_filtered
  end

end