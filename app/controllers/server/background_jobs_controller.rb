class Server::BackgroundJobsController < Server::ApplicationController
  
  def index
    @jobs = GoodJob::Job.where(finished_at: nil)
    @jobs_by_university = []
    @jobs_by_website = [] 
    @labels = @jobs.pluck(:labels)
                   .flatten
                   .compact
                   .uniq.each do |label|
      if label.start_with?('gid://osuny/University')
        university = GlobalID::Locator.locate(label)
        jobs = @jobs.where('labels @> ?', "{#{label}}")
        @jobs_by_university << [university.to_s, jobs.count]
      elsif label.start_with?('gid://osuny/Communication::Website')
        website = GlobalID::Locator.locate(label)
        jobs = @jobs.where('labels @> ?', "{#{label}}")
        @jobs_by_website << [website.to_s, jobs.count]
      end
    end
    @jobs_by_university.sort_by!(&:last).reverse!
    @jobs_by_website.sort_by!(&:last).reverse!
    breadcrumb
  end

  protected
  def breadcrumb
    super
    add_breadcrumb 'Jobs'
  end
end