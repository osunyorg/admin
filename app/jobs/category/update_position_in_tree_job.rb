class Category::UpdatePositionInTreeJob < ApplicationJob
  queue_as :mice

  def perform(university, klass, website: nil)
    Category::TreePositioner.new(university, klass, website: website).execute
  end

end