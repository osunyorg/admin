class Communication::Website::SetProgramsCategoriesJob < ApplicationJob
  queue_as :mice

  def execute
    website.set_programs_categories_safely
  end
end
