class I18nMigrationJob < ApplicationJob
  retry_on StandardError, attempts: 1

  queue_as :whale

  def perform
    Migrations::L10n.execute
  end
end
