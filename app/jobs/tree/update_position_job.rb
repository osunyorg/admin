class Tree::UpdatePositionJob < ApplicationJob
  queue_as :mice

  def perform(university, klass, website: nil)
    Tree::Positioner.new(university, klass, website: website).execute
  end

end
