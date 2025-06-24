class Admin::Communication::Websites::GitFilesController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::GitFile, through: :website

  def index
    @git_files = @git_files.ordered
                           .page(params[:page])
                           .per(100)
    breadcrumb
  end

  def show
    breadcrumb
    add_breadcrumb @git_file.computed_filename
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::GitFile.model_name.human(count: 2), admin_communication_website_git_files_path
  end
end