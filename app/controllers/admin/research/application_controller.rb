class Admin::Research::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb 'Recherche'
  end
end
