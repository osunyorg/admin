class Admin::Communication::Websites::Agenda::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::Agenda.model_name.human(count: 2)
  end

end
