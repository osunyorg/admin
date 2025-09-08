class Admin::Research::Journals::VolumesController < Admin::Research::Journals::ApplicationController
  load_and_authorize_resource class: Research::Journal::Volume, through: :journal

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @volumes = @volumes.ordered(current_language)
                       .page(params[:page])
    breadcrumb
  end

  def show
    @papers = @volume.papers.ordered_by_position
    breadcrumb
  end

  def static
    @about = @volume
    @website = @journal.websites.first
    if @website.nil?
      render plain: "Pas de site Web lié au journal"
    else
      render_as_plain_text
    end
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @volume.journal = @journal
    if @volume.save
      redirect_to admin_research_journal_volume_path(@volume), notice: t('admin.successfully_created_html', model: @volume.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @volume.update(volume_params)
      redirect_to admin_research_journal_volume_path(@volume), notice: t('admin.successfully_updated_html', model: @volume.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      render :edit, status: :unprocessable_content
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @volume.destroy
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @volume.to_s_in(current_language))
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
            :number,
            localizations_attributes: [
              :id, :language_id,
              :title, :slug, :keywords, :published, :published_at, :meta_description, :summary, :text,
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
            ]
          )
          .merge(university_id: current_university.id)
  end
end
