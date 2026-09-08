class Admin::Communication::Library::Files::RedirectionsController < Admin::Communication::Library::Files::ApplicationController
  before_action :load_and_authorize

  def index
  end

  # Modifie la propriété `file_server_slug` de la localisation de fichier
  # Conceptuellement, ça appartient plutôt à `FilesController`, mais :
  # - il est bien encombré déjà
  # - c'est utilisé par `FileServerApp.vue`
  # - ça doit render l'index pour renvoyer des données à jour (avec le nouvel alias)
  def change_server_slug
    @l10n.redirections.create(
      path: @l10n.file_server_path,
      university: @l10n.university,
    )
    @l10n.file_server_slug = params[:file_server_slug]
    @l10n.save
    render :index
  end

  def create
    @redirection = @l10n.redirections.create(
      path_without_extension: params[:path_without_extension],
      university: @l10n.university,
    )
    render :index
  end

  def destroy
    @redirection = @l10n.redirections.find(params[:id])
    @redirection.destroy
    render :index
  end

  protected

  def load_and_authorize
    @file = current_university.communication_files.find(params[:file_id])
    authorize! :create, @file
    @l10n = @file.localization_for(current_language)
  end
end
