class Admin::Research::ResearchersController < Admin::Research::ApplicationController

  has_scope :for_search_term
  
  def index
    @researchers = apply_scopes(current_university.people.researchers.accessible_by(current_ability)).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @researcher = current_university.people.researchers.accessible_by(current_ability).find(params[:id])
    @articles = @researcher.research_journal_articles.ordered.page(params[:page])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('research.researchers', count: 2),
                   admin_research_researchers_path
    breadcrumb_for @researcher
  end

end
