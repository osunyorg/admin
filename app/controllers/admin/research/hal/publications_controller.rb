class Admin::Research::Hal::PublicationsController < Admin::Research::Hal::ApplicationController
  before_action :load_publication, except: :index

  def index
    @publications = Research::Hal::Publication.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def static
    @about = @publication
    render layout: false
  end

  def destroy
    @publication.destroy
    redirect_to admin_research_hal_publications_path
  end

  protected

  def load_publication
    @publication = Research::Hal::Publication.find params[:id]
  end

  def breadcrumb
    super
    add_breadcrumb Research::Hal::Publication.model_name.human(count: 2),
                   admin_research_hal_publications_path
    breadcrumb_for @publication
  end

end
