class Admin::Communication::Medias::ApplicationController < Admin::Communication::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb t('communication.description.parts.media.title'), admin_communication_medias_path
    breadcrumb_for @media
  end
end
