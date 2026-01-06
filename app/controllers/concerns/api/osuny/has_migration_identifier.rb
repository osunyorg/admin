module Api::Osuny::HasMigrationIdentifier
  extend ActiveSupport::Concern

  included do
    before_action :ensure_migration_identifier_is_available, only: :create
    before_action :ensure_same_migration_identifier, only: :update
  end

  protected
  
  def integrity_checker
    raise NoMethodError, "You must implement the `integrity_checker` method in #{self.class.name}"
  end

  def ensure_migration_identifier_set
    render_missing_migration_identifier if integrity_checker.no_identifier?
  end

  def ensure_same_migration_identifier
    if integrity_checker.no_identifier?
      render_missing_migration_identifier
    elsif integrity_checker.different?
      render_migration_identifier_different
    end
  end

  def ensure_migration_identifier_is_available
    if integrity_checker.no_identifier?
      render_missing_migration_identifier
    elsif integrity_checker.already_used?
      render_migration_identifier_already_used
    end
  end

  def render_missing_migration_identifier
    render  json: { error: 'Missing migration identifier.' },
            status: :bad_request
  end

  def render_migration_identifier_different
    render  json: { error: 'Migration identifier does not match' },
            status: :unprocessable_content
  end

  def render_migration_identifier_already_used
    render  json: { error: 'Migration identifier already used' },
            status: :unprocessable_content
  end

end