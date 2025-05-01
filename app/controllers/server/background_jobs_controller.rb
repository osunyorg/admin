class Server::BackgroundJobsController < Server::ApplicationController
  
  def index
    @jobs = GoodJob::Job.where(finished_at: nil)
    @universities = {}
    labels = @jobs.pluck(:labels).flatten.compact.uniq
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
    @universities = @universities.sort_by { |key, value| value[:count] }.reverse!
    @universities.each do |id, hash|
      hash[:websites] = hash[:websites].sort_by { |value| value[:count] }.reverse!
    end
    breadcrumb
  end

  protected
  def breadcrumb
    super
    add_breadcrumb 'Jobs'
  end
end