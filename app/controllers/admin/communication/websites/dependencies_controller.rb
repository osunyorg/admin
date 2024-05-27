class Admin::Communication::Websites::DependenciesController < Admin::Communication::Websites::ApplicationController
  def index
    @dependencies = @website.recursive_dependencies.sort_by { |dependency| dependency.class.to_s }
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb 'Dépendances', admin_communication_website_dependencies_path
  end
end