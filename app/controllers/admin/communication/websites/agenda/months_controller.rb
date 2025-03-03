class Admin::Communication::Websites::Agenda::MonthsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Month,
                              through: :website

  def show
    breadcrumb
    add_breadcrumb  Communication::Website::Agenda::Year.model_name.human(count: 2),
                    admin_communication_website_agenda_years_path
    add_breadcrumb @month.year, admin_communication_website_agenda_year_path(website_id: @website.id, id: @month.year.id)
    add_breadcrumb @month
  end
end