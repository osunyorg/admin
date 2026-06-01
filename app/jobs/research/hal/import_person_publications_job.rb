class Research::Hal::ImportPersonPublicationsJob < ApplicationJob
  queue_as :elephants

  def perform(person)
    person.import_research_hal_publications_safely
  end
end
