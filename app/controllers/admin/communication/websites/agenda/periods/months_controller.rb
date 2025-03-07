class Admin::Communication::Websites::Agenda::Periods::MonthsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Period::Month,
                              through: :website,
                              through_association: :agenda_period_months

  include Admin::HasStaticAction
  include Admin::Localizable

  def show
    breadcrumb
    add_breadcrumb  Communication::Website::Agenda::Period::Year.model_name.human(count: 2),
                    admin_communication_website_agenda_periods_years_path
    add_breadcrumb  @l10n.year, 
                    admin_communication_website_agenda_periods_year_path(id: @month.year.id)
    add_breadcrumb  @l10n.to_month_name
  end
end