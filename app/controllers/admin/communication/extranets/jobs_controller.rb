class Admin::Communication::Extranets::JobsController < Admin::Communication::Extranets::ApplicationController
  def index
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_jobs)
  end
end