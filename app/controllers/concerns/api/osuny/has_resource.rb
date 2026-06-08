module Api::Osuny::HasResource
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: [:show, :update, :destroy]
    before_action :ensure_migration_identifier_is_available, only: :create
    before_action :ensure_same_migration_identifier, only: :update
  end

  protected
  
  def load_resource
    return resource if resource.present?
    resource = resource_list.find_by(id: params[:id])
    resource ||= resource_list.find_by!(migration_identifier: params[:id])
    resource
  end
  
  # :page
  def resource_name
    raise NoMethodError, "You must implement the `resource_name` method in #{self.class.name}"
  end
  
  # website.pages
  def resource_list
    raise NoMethodError, "You must implement the `resource_list` method in #{self.class.name}"
  end

  # page_params
  def resource_params
    send("#{resource_name}_params")
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end

  def resource=(value)
    instance_variable_set("@#{resource_name}", value)
  end
  
  def integrity_checker
    @integrity_checker ||= Osuny::Api::MigrationIdentifierIntegrityChecker.new(
      self[resource_name],
      resource_params,
      resource_list
    )
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
    render json: { error: 'Missing migration identifier.' }, status: :bad_request
  end

  def render_migration_identifier_different
    render json: { error: 'Migration identifier does not match' }, status: :unprocessable_content
  end

  def render_migration_identifier_already_used
    render json: { error: 'Migration identifier already used' }, status: :unprocessable_content
  end
end