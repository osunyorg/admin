class Osuny::Picker::Communication::Website::Jobboard::Job < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.jobboard_jobs
  end

  def categories
    @categories ||= website.jobboard_categories
  end

end