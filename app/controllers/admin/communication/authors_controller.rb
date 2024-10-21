class Admin::Communication::AuthorsController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: "University::Person",
                              through: :current_university,
                              through_association: :people

  include Admin::Localizable

  def index
    @authors =  current_university.people
                                  .authors
                                  .filter_by(params[:filters], current_language)
                                  .ordered(current_language)
                                  .page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Localization::Author.model_name.human(count: 2), admin_communication_authors_path
  end

end
