class Admin::Communication::Extranets::AlumniController < Admin::Communication::Extranets::ApplicationController
  def index
    @about = @extranet.about
    @alumni = @extranet.alumni
    @cohorts = @extranet.cohorts
    @years = @extranet.years
    @organizations = @extranet.organizations.for_language_id(current_university.default_language_id)
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_alumni)
  end
end