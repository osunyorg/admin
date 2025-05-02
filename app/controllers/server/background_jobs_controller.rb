class Server::BackgroundJobsController < Server::ApplicationController
  
  def index
    @analyzer = BackgroundJobs::Analyzer.new
    @jobs = @analyzer.jobs
    @universities = @analyzer.universities
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb 'Jobs'
  end
end