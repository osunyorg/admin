class I18nMigrationJob < ApplicationJob
  queue_as :whale

  def perform
    Migrations::L10n.execute
  end
end