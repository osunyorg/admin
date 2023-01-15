class Admin::Research::PublicationsController < Admin::Research::ApplicationController

  def index
    @publications = Research::Publication.ordered.page(params[:page])
    breadcrumb
  end

  def show
    @publication = Research::Publication.find params[:id]
    breadcrumb
  end

  def update
    @publication = Research::Publication.find params[:id]
    # TODO update from api
    redirect_to admin_research_publication_path(@publication)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Publication.model_name.human(count: 2),
                   admin_research_publications_path
    breadcrumb_for @publication
  end

end
