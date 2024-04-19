class Admin::Communication::Websites::GitAnalysisController < Admin::Communication::Websites::ApplicationController
  # Ce n'est pas une ressource nested comme dependencies, 
  # donc on doit charger explicitement pour utiliser id et pas website_id
  load_and_authorize_resource :website,
                              id_param: :id,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  def index
    # byebug
    @orphans = @website.git_file_orphans.ordered
    @layouts = @website.git_file_layouts.ordered
    breadcrumb
    add_breadcrumb 'Analyse Git'
  end

  def launch
    Git::OrphanAndLayoutAnalyzer.new(@website).launch
    redirect_back fallback_location: admin_communication_website_path, notice: 'Analyse lancée'
  end
end