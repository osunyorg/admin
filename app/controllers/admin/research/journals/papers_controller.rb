class Admin::Research::Journals::PapersController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Paper, through: :journal

  include Admin::Reorderable

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def static
    @about = @paper
    @website = @journal.websites.first
    if @website.nil?
      render plain: "Pas de site Web lié au journal"
    else
      render layout: false
    end
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @paper.assign_attributes(
      journal: @journal,
      university: current_university,
      updated_by: current_user
    )
    if @paper.save
      redirect_to admin_research_journal_paper_path(@paper), notice: t('admin.successfully_created_html', model: @paper.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @paper.updated_by = current_user
    if @paper.update(paper_params)
      redirect_to admin_research_journal_paper_path(@paper), notice: t('admin.successfully_updated_html', model: @paper.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @paper.destroy
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @paper.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Paper.model_name.human(count: 2), admin_research_journal_papers_path
    breadcrumb_for @paper
  end

  def paper_params
    params.require(:research_journal_paper)
          .permit(
            :title, :slug, :text, :published, :published_at, :received_at, :accepted_at,
            :summary, :abstract, :meta_description, :doi,
            :pdf, :references, :keywords, :research_journal_volume_id, :kind_id, person_ids: [])
          .merge(university_id: current_university.id)
  end
end
