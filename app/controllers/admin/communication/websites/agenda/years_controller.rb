class Admin::Communication::Websites::Agenda::YearsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Year,
                              through: :website

  include Admin::HasStaticAction

  def index
    breadcrumb
  end
  
  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Agenda::Year.model_name.human(count: 2),
                    admin_communication_website_agenda_years_path
    breadcrumb_for @year
  end
end