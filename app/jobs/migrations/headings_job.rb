class Migrations::HeadingsJob < ApplicationJob
  queue_as :migration

  def perform
    Migrations::Headings.migrate
  end
end
