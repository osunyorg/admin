class Admin::Research::PublicationsController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Publication

  has_scope :for_search_term

  def index
    @publications = apply_scopes(@publications).ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def static
    @about = @publication
    @website = @publication.websites&.first || current_university.websites.first
    render_as_plain_text
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @publication.save
      redirect_to [:admin, @publication], notice: t('admin.successfully_created_html', model: @publication.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @publication.update(publication_params)
      redirect_to [:admin, @publication], notice: t('admin.successfully_updated_html', model: @publication.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @publication.destroy
    redirect_to admin_research_publications_url, notice: t('admin.successfully_destroyed_html', model: @publication.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Publication.model_name.human(count: 2), admin_research_publications_path
    breadcrumb_for @publication
  end

  def publication_params
    params.require(:research_publication)
          .permit(:title, :publication_date, :abstract, :authors_list, :doi, :ref, :journal_title, :url, :open_access, :citation_full, researcher_ids: [])
  end
end
