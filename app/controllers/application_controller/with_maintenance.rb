module ApplicationController::WithMaintenance
  extend ActiveSupport::Concern

  included do
    before_action :check_maintenance
  end

  protected

  def check_maintenance
    if  ENV['MAINTENANCE'] && 
        current_user&.role != 'server_admin'
      redirect_to '/maintenance' 
    end
  end
end
