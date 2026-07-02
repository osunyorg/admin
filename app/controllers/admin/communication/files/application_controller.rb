class Admin::Communication::Files::ApplicationController < Admin::Communication::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb t('communication.description.parts.file.title'), admin_communication_files_path
    breadcrumb_for @file
  end
end
