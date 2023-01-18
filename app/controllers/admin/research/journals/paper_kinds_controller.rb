class Admin::Research::Journals::PaperKindsController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Paper::Kind, through: :journal

  def index
    breadcrumb
  end
  
  def show
    @papers = @paper_kind.papers.page params[:page]
    breadcrumb
  end

  def static
    @about = @paper_kind
    render layout: false
  end

  def new
    breadcrumb
  end
  
  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @paper_kind.assign_attributes(
      journal: @journal,
      university: current_university
    )
    if @paper_kind.save_and_sync
      redirect_to admin_research_journal_paper_kind_path(@paper_kind), notice: t('admin.successfully_created_html', model: @paper_kind.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @paper_kind.update_and_sync(paper_kind_params)
      redirect_to admin_research_journal_paper_kind_path(@paper_kind), notice: t('admin.successfully_updated_html', model: @paper_kind.to_s)
    else
      byebug
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @paper_kind.destroy_and_sync
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @paper_kind.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Paper::Kind.model_name.human(count: 2), admin_research_journal_paper_kinds_path
    breadcrumb_for @paper_kind
  end

  def paper_kind_params
    params.require(:research_journal_paper_kind).permit(:title, :slug)
  end
end
