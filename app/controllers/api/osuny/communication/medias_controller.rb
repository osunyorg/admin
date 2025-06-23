class Api::Osuny::Communication::MediasController < Api::Osuny::ApplicationController
  before_action :ensure_url_param,
                :create_blob_from_url,
                only: :create

  def show
    @media = current_university.communication_medias.find(params[:id])
  end

  def create
    Communication::Media.transaction do
      @media = Communication::Media.create_from_blob(@blob)
      @media.localizations.where(language_id: current_university.default_language_id).first_or_create(
        name: File.basename(@media.original_filename, ".*").humanize
      )
    end

    if @media.persisted?
      render :show, status: :created
    else
      render json: { errors: @media.errors }, status: :unprocessable_entity
    end
  end

  protected

  def ensure_url_param
    render(
      json: { error: "URL parameter is required" },
      status: :unprocessable_entity
    ) if params[:url].blank?
  end

  def create_blob_from_url
    begin
      uri = URI.parse(url)
      @blob = ActiveStorage::Blob.create_and_upload!(
        io: URI.open(uri),
        filename: File.basename(uri.path)
      )
      @blob.update_column :university_id, current_university.id
    rescue StandardError => e
      render(
        json: { error: "Failed to create blob from URL: #{e.message}" },
        status: :unprocessable_entity
      )
    end
  end
end
