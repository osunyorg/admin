class Api::Osuny::Communication::Websites::Portfolio::ProjectsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :load_project, only: [:show, :update, :destroy] # Before HasMigrationIdentifier
  include Api::Osuny::HasMigrationIdentifier

  def index
    @projects = paginate(website.portfolio_projects.includes(:localizations))
  end

  def show
  end

  def create
    @project = website.portfolio_projects.build
    @project.assign_attributes(project_params)
    if @project.save
      render :show, status: :created
    else
      render json: { errors: @project.errors }, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      render :show
    else
      render json: { errors: @project.errors }, status: :unprocessable_content
    end
  end

  def upsert
    projects_params = params[:projects] || []
    every_project_has_migration_identifier = projects_params.all? { |project_params|
      project_params[:migration_identifier].present?
    }
    unless every_project_has_migration_identifier
      render_missing_migration_identifier
      return
    end

    permitted_projects_params = projects_params.map { |unpermitted_params|
      project_params_for_upsert(unpermitted_params)
    }
    @successfully_created_projects = []
    @successfully_updated_projects = []
    @invalid_projects_with_index = []
    permitted_projects_params.each_with_index do |permitted_project_params, index|
      project = website.portfolio_projects.find_by(migration_identifier: permitted_project_params[:migration_identifier])
      if project.present?
        if project.update(permitted_project_params)
          @successfully_updated_projects << project
        else
          @invalid_projects_with_index << { project: project, index: index }
        end
      else
        project = website.portfolio_projects.build(permitted_project_params)
        if project.save
          @successfully_created_projects << project
        else
          @invalid_projects_with_index << { project: project, index: index }
        end
      end
    end

    status = @invalid_projects_with_index.any? ? :unprocessable_content : :ok
    render 'upsert', status: status
  end

  def destroy
    @project.really_destroy!
    head :no_content
  end

  protected

  def integrity_checker
    @integrity_checker ||= Osuny::Api::MigrationIdentifierIntegrityChecker.new(@project, project_params, website.portfolio_projects)
  end

  def load_project
    @project = website.portfolio_projects.find(params[:id])
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :title, :meta_description,
      :published, :published_at, :slug, :subtitle, :summary, :_destroy,
      featured_image: [:blob_id, :url, :alt, :credit, :_destroy],
      **nested_blocks_params
    ]
  end

  def project_params
    @project_params ||= begin
      permitted_params = params.require(:project)
                          .permit(
                            :migration_identifier, :full_width, :year, :bodyclass, category_ids: [], localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params, @project) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def project_params_for_upsert(project_params)
    permitted_params = project_params
                          .permit(
                            :migration_identifier, :full_width, :year, :bodyclass, category_ids: [], localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
    project = website.portfolio_projects.find_by(migration_identifier: permitted_params[:migration_identifier])
    permitted_params[:id] = project.id if project.present?
    set_l10n_attributes(permitted_params, project) if permitted_params[:localizations].present?
    permitted_params
  end
end
