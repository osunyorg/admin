class Osuny::Picker::Research::Journal::Paper < Osuny::Picker

  def journal
    context
  end

  def objects
    @objects ||= journal.papers
  end

end