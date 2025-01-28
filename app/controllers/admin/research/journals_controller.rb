class Admin::Research::JournalsController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal,
                              through: :current_university,
                              through_association: :research_journals

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @journals = @journals.filter_by(params[:filters], current_language)
                         .ordered(current_language)
                         .page(params[:page])
    breadcrumb
  end

  def show
    @papers = @journal.papers
                      .ordered(current_language)
                      .limit(10)
    @paper_kinds =  @journal.paper_kinds
                            .ordered(current_language)
    @volumes =  @journal.volumes
                        .ordered(current_language)
                        .limit(6)
    @hero_summary = true
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    if @journal.save
      redirect_to [:admin, @journal], notice: t('admin.successfully_created_html', model: @journal.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @journal.update(journal_params)
      redirect_to [:admin, @journal], notice: t('admin.successfully_updated_html', model: @journal.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal.destroy
    redirect_to admin_research_journals_url, notice: t('admin.successfully_destroyed_html', model: @journal.to_s_in(current_language))
  end

  protected

  def journal_params
    params.require(:research_journal)
          .permit(
            localizations_attributes: [
              :id, :language_id,
              :title, :meta_description, :summary, :issn
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
