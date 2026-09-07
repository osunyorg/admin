class Osuny::Picker::Research::Journal::Volume < Osuny::Picker

  def journal
    context
  end

  def objects
    @objects ||= journal.volumes
  end

end