class Admin::Research::ResearchersController < Admin::Research::ApplicationController

  def index
    @researchers = current_university.members.researchers.accessible_by(current_ability).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @researcher = current_university.members.authors.accessible_by(current_ability).find(params[:id])
    @articles = @researcher.research_journal_articles.ordered.page(params[:page])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Researcher.model_name.human(count: 2),
                   admin_research_researchers_path
    breadcrumb_for @researcher
  end

end
