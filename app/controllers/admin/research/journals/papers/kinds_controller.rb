class Admin::Research::Journals::Papers::KindsController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Paper::Kind,
                              through: :journal,
                              through_association: :paper_kinds

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @feature_nav = 'navigation/admin/research/journal/papers'
    breadcrumb
  end

  def show
    @papers = @kind.papers.page params[:page]
    breadcrumb
    add_breadcrumb @l10n
  end

  def new
    breadcrumb
    add_breadcrumb t('create')
  end

  def edit
    breadcrumb
    add_breadcrumb @l10n, admin_research_journal_kind_path(@kind)
    add_breadcrumb t('edit')
  end

  def create
    @kind.assign_attributes(
      journal: @journal
    )
    if @kind.save
      redirect_to admin_research_journal_kind_path(@kind), notice: t('admin.successfully_created_html', model: @kind.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('create')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @kind.update(kind_params)
      redirect_to admin_research_journal_kind_path(@kind), notice: t('admin.successfully_updated_html', model: @kind.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb @l10n, admin_research_journal_kind_path(@kind)
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @kind.destroy
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @kind.to_s_in(current_language))
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Paper.model_name.human(count: 2), admin_research_journal_papers_path
    add_breadcrumb Research::Journal::Paper::Kind.model_name.human(count: 2), admin_research_journal_kinds_path
  end

  def kind_params
    params.require(:research_journal_paper_kind)
          .permit(
            localizations_attributes: [
              :id, :language_id,
              :title, :slug
            ]
          )
          .merge(university_id: current_university.id)
  end
end
