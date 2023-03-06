class Admin::Communication::Extranets::AssetsController < Admin::Communication::Extranets::ApplicationController
  def index
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_assets)
  end
end