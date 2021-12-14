class Admin::Communication::Website::AuthorsController < Admin::Communication::Website::ApplicationController

  def index
    @authors = current_university.members.authors.accessible_by(current_ability).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @author = current_university.members.authors.accessible_by(current_ability).find(params[:id])
    @posts = @author.communication_website_posts.ordered.page(params[:page])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::Author.model_name.human(count: 2),
                   admin_communication_website_authors_path
    breadcrumb_for @author
  end

end
