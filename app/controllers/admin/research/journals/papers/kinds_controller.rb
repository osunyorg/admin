class Admin::Research::Journals::Papers::KindsController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Paper::Kind, through: :journal

  def index
    breadcrumb
  end
  
  def show
    @papers = @kind.papers.page params[:page]
    breadcrumb
    add_breadcrumb @kind
  end

  def static
    @about = @kind
    @website = @journal.websites.first
    if @website.nil?
      render plain: "Pas de site Web lié au journal"
    else
      render layout: false
    end
  end

  def new
    breadcrumb
    add_breadcrumb t('create')
  end
  
  def edit
    breadcrumb
    add_breadcrumb @kind, admin_research_journal_kind_path(@kind)
    add_breadcrumb t('edit')
  end

  def create
    @kind.assign_attributes(
      journal: @journal,
      university: current_university
    )
    if @kind.save_and_sync
      redirect_to admin_research_journal_kind_path(@kind), notice: t('admin.successfully_created_html', model: @paper_kind.to_s)
    else
      breadcrumb
      add_breadcrumb t('create')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @kind.update_and_sync(kind_params)
      redirect_to admin_research_journal_kind_path(@kind), notice: t('admin.successfully_updated_html', model: @paper_kind.to_s)
    else
      breadcrumb
      add_breadcrumb @kind, admin_research_journal_kind_path(@kind)
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @kind.destroy_and_sync
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @paper_kind.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Paper::Kind.model_name.human(count: 2), admin_research_journal_kinds_path
  end

  def kind_params
    params.require(:research_journal_paper_kind).permit(:title, :slug)
  end
end
