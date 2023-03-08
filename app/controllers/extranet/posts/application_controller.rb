class Extranet::Posts::ApplicationController < Extranet::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_posts), posts_root_path
  end
end