class Communication::Website::AnalyseAllJob < ApplicationJob
  queue_as :elephants

  def perform
    Communication::Website.find_each do |website|
      website.analyse_repository
    end
  end

end
