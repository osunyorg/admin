class Admin::Research::Journals::PapersController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Paper, through: :journal

  include Admin::HasStaticAction
  include Admin::Localizable
  include Admin::Reorderable

  def index
    @papers = @papers.ordered(current_language)
                     .page(params[:page])
    @feature_nav = 'navigation/admin/research/journal/papers'
    breadcrumb
  end

  def show
    breadcrumb
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
      updated_by: current_user
    )
    if @paper.save
      redirect_to admin_research_journal_paper_path(@paper), notice: t('admin.successfully_created_html', model: @paper.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @paper.updated_by = current_user
    if @paper.update(paper_params)
      redirect_to admin_research_journal_paper_path(@paper), notice: t('admin.successfully_updated_html', model: @paper.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @paper.destroy
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @paper.to_s_in(current_language))
  end

  private

  # For Admin::Reorderable
  def model
    Research::Journal::Paper
  end

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Paper.model_name.human(count: 2), admin_research_journal_papers_path
    breadcrumb_for @paper
  end

  def paper_params
    params.require(:research_journal_paper)
          .permit(
            :received_at, :accepted_at,
            :doi, :research_journal_volume_id, :kind_id, person_ids: [],
            localizations_attributes: [
              :id, :language_id,
              :title, :slug, :text, :published, :published_at, :summary, :abstract,
              :meta_description, :authors_list, :pdf, :pdf_delete, :bibliography, :keywords,
            ])
          .merge(university_id: current_university.id)
  end
end
