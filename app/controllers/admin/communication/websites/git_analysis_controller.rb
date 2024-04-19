class Admin::Communication::Websites::GitAnalysisController < Admin::Communication::Websites::ApplicationController
  # Ce n'est pas une ressource nested comme dependencies, 
  # donc on doit charger explicitement pour utiliser id et pas website_id
  load_and_authorize_resource :website,
                              id_param: :id,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  def index
    @orphans = @website.git_file_orphans.ordered
    @layouts = @website.git_file_layouts.ordered
    breadcrumb
    add_breadcrumb t('admin.communication.website.git_file.analysis.title')
  end

  def launch
    Git::OrphanAndLayoutAnalyzer.new(@website).launch
    redirect_back fallback_location: admin_communication_website_path, notice: t('admin.communication.website.git_file.analysis.launched')
  end
end