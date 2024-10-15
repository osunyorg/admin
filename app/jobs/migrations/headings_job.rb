class Migrations::HeadingsJob < ApplicationJob
  queue_as :whale

  def perform
    Migrations::Headings.migrate
  end
end
