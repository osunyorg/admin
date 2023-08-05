class Admin::Communication::Blocks::HeadingsController < Admin::Communication::Blocks::ApplicationController
  load_and_authorize_resource class: Communication::Block::Heading,
                              through: :current_university,
                              through_association: :communication_block_headings

  def reorder
    parent_id = params[:heading]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      @heading = current_university.communication_block_headings.find(id)
      @heading.update_columns parent_id: parent_id,
                              parent_id: nil,
                              level: Communication::Block::Heading::DEFAULT_LEVEL,
                              position: index + 1
    end
    if @heading.about&.respond_to?(:is_direct_object?)
      @heading.about.is_direct_object?  ? @heading.about.sync_with_git
                                        : @heading.about.touch # Sync indirect object's direct sources through after_touch
    end
  end

  def new
    @heading.about = PolymorphicObjectFinder.find params, :about
    breadcrumb
  end

  def edit
    breadcrumb
  end

  def create
    if @heading.save
      redirect_to about_path,
                  notice: t('admin.successfully_created_html', model: @heading.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @heading.update(heading_params)
      redirect_to about_path,
                  notice: t('admin.successfully_updated_html', model: @heading.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    path = about_path
    @heading.destroy
    redirect_to path,
                notice: t('admin.successfully_destroyed_html', model: @heading.to_s)
  end

  protected

  # TODO factorize
  def website_id
    params[:website_id] || @heading.about&.website.id
  rescue
  end

  def extranet_id
    params[:extranet_id] || @heading.about&.extranet.id
  rescue
  end

  def journal_id
    params[:journal_id] || @heading.about&.journal.id
  rescue
  end

  def about_path
    # La formation ou la page concernée
    path_method = "admin_#{@heading.about.class.base_class.to_s.parameterize.underscore}_path"
    path_method_options = {
      id: @heading.about_id,
      website_id: website_id,
      extranet_id: extranet_id,
      journal_id: journal_id
    }
    path_method_options[:lang] = @heading.about.language.iso_code if @heading.about.respond_to?(:language)
    public_send path_method, **path_method_options
  end
  # TODO /factorize

  def breadcrumb
    super
    add_breadcrumb @heading.about, about_path
    if @heading.new_record?
      add_breadcrumb t('admin.communication.blocks.headings.add')
    else
      add_breadcrumb @heading
    end
  end

  def heading_params
    params.require(:communication_block_heading)
          .permit(:about_id, :about_type, :title)
          .merge(university_id: current_university.id)
  end
end
