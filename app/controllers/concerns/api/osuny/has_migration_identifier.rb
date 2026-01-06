module Api::Osuny::HasMigrationIdentifier
  extend ActiveSupport::Concern

  included do
    append_before_action :ensure_migration_identifier_is_available, only: :create
    append_before_action :ensure_same_migration_identifier, only: :update
  end

  protected
  
  def integrity_checker
    raise NoMethodError, "You must implement the `integrity_checker` method in #{self.class.name}"
  end

  def ensure_same_migration_identifier
    render  json: { error: 'Migration identifier does not match' },
            status: :unprocessable_content if integrity_checker.different?
  end

  def ensure_migration_identifier_is_available
    render  json: { error: 'Migration identifier already used' },
            status: :unprocessable_content if integrity_checker.already_used?
  end

  def render_on_missing_migration_identifier
    render  json: { error: 'Missing migration identifier.' },
            status: :bad_request
  end

end