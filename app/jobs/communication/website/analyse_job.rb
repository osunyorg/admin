class Communication::Website::AnalyseJob < Communication::Website::BaseJob
  queue_as :elephants

  def execute
    website.analyse_repository_safely
  end

end
