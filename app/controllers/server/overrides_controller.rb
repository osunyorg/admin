class Server::OverridesController < Server::ApplicationController

  def index
    @overrides = Communication::Website::GitFile::Layout.overrides
    breadcrumb
  end

  def show
    @path = params[:path]
    @layouts = Communication::Website::GitFile::Layout.where(path: @path)
    breadcrumb
    add_breadcrumb @path
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::GitFile::Layout.model_name.human(count: 2), server_overrides_path
  end

end