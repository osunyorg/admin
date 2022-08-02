class Admin::Research::Journals::VolumesController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Volume, through: :journal

  def index
    @volumes = @volumes.ordered
    breadcrumb
  end

  def show
    @papers = @volume.papers.ordered
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @volume.add_unsplash_image params[:unsplash]
    @volume.assign_attributes(journal: @journal, university: current_university)
    if @volume.save_and_sync
      redirect_to admin_research_journal_volume_path(@volume), notice: t('admin.successfully_created_html', model: @volume.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @volume.add_unsplash_image params[:unsplash]
    if @volume.update_and_sync(volume_params)
      redirect_to admin_research_journal_volume_path(@volume), notice: t('admin.successfully_updated_html', model: @volume.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @volume.destroy_and_sync
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @volume.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Volume.model_name.human(count: 2), admin_research_journal_volumes_path
    breadcrumb_for @volume
  end

  def volume_params
    params.require(:research_journal_volume)
          .permit(
            :title, :slug, :number, :keywords, :published, :published_at, :description, :text,
            :featured_image, :featured_image_infos, :featured_image_delete, :featured_image_alt, :featured_image_credit
          )
          .merge(university_id: current_university.id)
  end
end
