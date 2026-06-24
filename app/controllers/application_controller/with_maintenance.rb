module ApplicationController::WithMaintenance
  extend ActiveSupport::Concern

  included do
    before_action :check_maintenance
  end

  protected

  def check_maintenance
    # TODO(roles-cache): prédicat sur le cache `role` -> has_role?('server_admin') si cache supprimé.
    if (ENV['MAINTENANCE'] == 'true') && !current_user&.server_admin?
      redirect_to '/maintenance' 
    end
  end
end
