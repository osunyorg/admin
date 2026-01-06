class Api::Osuny::Communication::MediasController < Api::Osuny::ApplicationController
  before_action :create_blob, only: :create

  def show
    @media = current_university.communication_medias.find(params[:id])
  end

  def create
    @media = Communication::Media.create_from_blob(@blob)
    if @media.persisted?
      render :show, status: :created
    else
      render json: { errors: @media.errors }, status: :unprocessable_content
    end
  end

  protected

  def create_blob
    if params[:url].present?
      create_blob_from_url
    elsif params[:file].present?
      create_blob_from_file
    else
      render(
        json: { error: "Either URL or file parameter is required" },
        status: :unprocessable_content
      )
    end
  rescue StandardError => e
    render(
      json: { error: "Failed to create blob: #{e.message}" },
      status: :unprocessable_content
    )
  end

  def create_blob_from_url
    uri = URI(params[:url])
    @blob = ActiveStorage::Blob.create_and_upload!(
      io: uri.open,
      filename: File.basename(uri.path)
    )
    @blob.update_column :university_id, current_university.id
  end

  def create_blob_from_file
    file = params[:file]
    @blob = ActiveStorage::Blob.create_and_upload!(
      io: file.tempfile,
      filename: file.original_filename
    )
    @blob.update_column :university_id, current_university.id
  end
end
