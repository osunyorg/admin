class Admin::Communication::Medias::ApplicationController < Admin::Communication::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Media.model_name.human(count: 2), admin_communication_medias_path
    breadcrumb_for @media
  end
end
