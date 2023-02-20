class Admin::Research::Hal::AuthorsController < Admin::Research::Hal::ApplicationController
  before_action :load_author, except: :index
  before_action :load_researcher, only: [:connect_researcher, :disconnect_researcher]

  def index
    @authors = Research::Hal::Author.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def connect_researcher
    @author.connect_researcher @researcher
    redirect_back(fallback_location: admin_research_researcher_path(@researcher))   
  end
  
  def disconnect_researcher
    @author.disconnect_researcher @researcher
    redirect_back(fallback_location: admin_research_researcher_path(@researcher))   
  end

  def destroy
    @author.destroy
    redirect_to admin_research_hal_authors_path
  end

  protected

  def load_author
    @author = Research::Hal::Author.find params[:id]
  end

  def load_researcher
    @researcher = current_university.university_people.find params[:researcher_id]
  end

  def breadcrumb
    super
    add_breadcrumb Research::Hal::Author.model_name.human(count: 2),
                   admin_research_hal_authors_path
    breadcrumb_for @author
  end

end
