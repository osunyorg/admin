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
    previous_path = @l10n.file_server_path
    @l10n.file_server_slug = params[:file_server_slug]
    if @l10n.save(context: :redirection)
      # Si une redirection existait avec le nouveau chemin, on la supprime.
      # Les permaliens priment toujours sur les redirections.
      Communication::File::Redirection.remove(@l10n.university, @l10n.file_server_path)
      # Le précédent permalien devient une redirection.
      Communication::File::Redirection.add(@l10n, previous_path)
      render :index
    else
      render_error(@l10n)
    end
  end

  def create
    @redirection = @l10n.redirections.create(
      path_without_extension: params[:path_without_extension],
      university: @l10n.university,
    )
    if @redirection.persisted?
      render :index
    else
      render_error(@redirection)
    end
  end

  def destroy
    @redirection = @l10n.redirections.find(params[:id])
    if @redirection.destroy
      render :index
    else
      render_error(@redirection)
    end
  end

  protected

  def load_and_authorize
    @file = current_university.communication_files.find(params[:file_id])
    authorize! :create, @file
    @l10n = @file.localization_for(current_language)
  end

  def render_error(redirection)
    render json: {
      error: redirection.errors.full_messages.to_sentence,
      status: 400
    }, status: 400
  end
end
