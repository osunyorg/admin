class Admin::Communication::Extranets::AlumniController < Admin::Communication::Extranets::ApplicationController
  def index
    @about = @extranet.about
    @alumni = @extranet.alumni
    @cohorts = @extranet.cohorts
    @years = @extranet.years
    @organizations = @extranet.organizations
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_alumni)
  end
end