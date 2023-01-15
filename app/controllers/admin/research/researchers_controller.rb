class Admin::Research::ResearchersController < Admin::Research::ApplicationController

  has_scope :for_search_term

  def index
    @researchers = apply_scopes(current_university.people.researchers.accessible_by(current_ability)).ordered.page(params[:page])
    breadcrumb
  end

  def show
    load
    if @researcher.hal_identity?
      @researcher.load_research_publications!
    else
      @possible_hal_authors = @researcher.possible_hal_authors
    end
    @papers = @researcher.research_journal_papers.ordered.page(params[:page])
    breadcrumb
  end

  def update
    load
    @researcher.update_column :hal_doc_identifier, params[:hal_doc_identifier] if params.has_key?(:hal_doc_identifier)
    @researcher.update_column :hal_form_identifier, params[:hal_form_identifier] if params.has_key?(:hal_form_identifier)
    @researcher.update_column :hal_person_identifier, params[:hal_person_identifier] if params.has_key?(:hal_person_identifier)
    @researcher.load_research_publications!
    redirect_to admin_research_researcher_path(@researcher)
  end

  protected

  def load
    @researcher = current_university.people.researchers.accessible_by(current_ability).find(params[:id])
  end

  def breadcrumb
    super
    add_breadcrumb t('research.researchers', count: 2),
                   admin_research_researchers_path
    breadcrumb_for @researcher
  end

end
