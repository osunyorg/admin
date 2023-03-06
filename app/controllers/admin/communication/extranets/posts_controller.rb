class Admin::Communication::Extranets::PostsController < Admin::Communication::Extranets::ApplicationController
  def index
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_posts)
  end
end