class Admin::Research::ResearchersController < Admin::Research::ApplicationController
  load_and_authorize_resource class: "University::Person",
                              through: :current_university,
                              through_association: :people

  include Admin::Localizable
  include Admin::HasStaticAction

  def index
    @researchers = current_university.people
                                     .researchers
                                     .filter_by(params[:filters], current_language)
                                     .tmp_original # TODO L10N : To remove
                                     .ordered(current_language)
                                     .page(params[:page])
    breadcrumb
  end

  def show
    @papers =  @researcher.research_journal_papers
                          .ordered(current_language)
                          .page(params[:page])
    @hal_authors_with_same_name = Research::Hal::Author.import_from_hal @l10n.to_s
    breadcrumb
    add_breadcrumb @l10n
  end

  def static
    @l10n = University::Person::Localization::Researcher.find(@l10n.id)
    super
  end

  def sync_with_hal
    begin
      Research::Hal.pause_git_sync
      @researcher.import_research_hal_publications!
    ensure
      Research::Hal.unpause_git_sync
    end
    redirect_to admin_research_researcher_path(@researcher), notice: t('research.hal.synchronization_done')
  end

  def update
    [
      :hal_doc_identifier,
      :hal_form_identifier,
      :hal_person_identifier
    ].each do |key|
      @researcher.update_column key, params[key] if params.has_key?(key)
    end
    redirect_to admin_research_researcher_path(@researcher)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Researcher.model_name.human(count: 2), admin_research_researchers_path
  end

end
