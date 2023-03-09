class Extranet::OrganizationsController < Extranet::ApplicationController

  def search
    @term = params[:term].to_s
    @organizations = current_university.organizations
                                      .search_by_siren_or_name(@term)
                                      .ordered
  end


end
