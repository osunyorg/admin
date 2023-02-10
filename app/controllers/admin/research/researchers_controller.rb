class Admin::Research::ResearchersController < Admin::Research::ApplicationController

  has_scope :for_search_term

  def index
    @researchers = apply_scopes(current_university.people)
                    .for_language_id(current_university.default_language_id)
                    .researchers
                    .accessible_by(current_ability)
                    .ordered
                    .page(params[:page])
    breadcrumb
  end

  def show
    load
    @possible_hal_authors = @researcher.possible_hal_authors unless @researcher.hal_identity?
    @papers = @researcher.research_journal_papers.ordered.page(params[:page])
    breadcrumb
    add_breadcrumb @researcher
  end

  def update
    load
    @researcher.update_column :hal_doc_identifier, params[:hal_doc_identifier] if params.has_key?(:hal_doc_identifier)
    @researcher.update_column :hal_form_identifier, params[:hal_form_identifier] if params.has_key?(:hal_form_identifier)
    @researcher.update_column :hal_person_identifier, params[:hal_person_identifier] if params.has_key?(:hal_person_identifier)
    @researcher.load_research_publications
    redirect_to admin_research_researcher_path(@researcher)
  end

  protected

  def load
    @researcher = current_university.people
                                    .for_language_id(current_university.default_language_id)
                                    .researchers
                                    .accessible_by(current_ability)
                                    .find(params[:id])
    @papers = @researcher.research_journal_papers.ordered.page(params[:page])
  end

  def breadcrumb
    super
    add_breadcrumb t('research.researchers', count: 2), admin_research_researchers_path
  end

end
