class BackgroundJobs::Analyzer

  def jobs
    @jobs ||= GoodJob::Job.where(finished_at: nil)
  end

  def universities
    unless @universities
      extract_universities
      extract_websites
      sort_everything
    end
    @universities
  end

  protected

  def labels
    @labels ||= jobs.pluck(:labels).flatten.compact.uniq
  end

  def extract_universities
    @universities = {}
    labels.each do |label|
      next unless label.start_with?('gid://osuny/University')
      university = GlobalID::Locator.locate(label)
      jobs = @jobs.where('labels @> ?', "{#{label}}")
      @universities[university.id] = {
        label: university.to_s,
        count: jobs.count,
        websites: []
      }
    end
  end

  def extract_websites
    labels.each do |label|
      next unless label.start_with?('gid://osuny/Communication::Website')
      website = GlobalID::Locator.locate(label)
      university = website.university
      jobs = @jobs.where('labels @> ?', "{#{label}}")
      @universities[university.id][:websites] << {
        label: website.to_s,
        count: jobs.count
      }
    end
  end

  def sort_everything
    @universities = @universities.sort_by { |key, value| value[:count] }.reverse!
    @universities.each do |id, hash|
      hash[:websites] = hash[:websites].sort_by { |value| value[:count] }.reverse!
    end
  end
end