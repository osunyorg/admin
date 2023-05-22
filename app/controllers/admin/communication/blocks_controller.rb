class Admin::Communication::BlocksController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Block,
                              through: :current_university,
                              through_association: :communication_blocks

  def reorder
    heading_id = params[:heading]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      @block = current_university.communication_blocks.find(id)
      @block.position = index + 1
      @block.heading_id = heading_id
      @block.save
    end
  end

  def new
    @block.about = Polymorphic.find params, :about
    breadcrumb
  end

  def show
    breadcrumb
  end

  def edit
    @element = @block.template.default_element
    breadcrumb
  end

  def create
    if @block.save
      redirect_to [:edit, :admin, @block],
                  notice: t('admin.successfully_created_html', model: @block.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @block.update(block_params)
      redirect_to about_path,
                  notice: t('admin.successfully_updated_html', model: @block.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:edit, :admin, @block.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @block.to_s)
  end

  def destroy
    path = about_path
    @block.destroy
    redirect_to path,
                notice: t('admin.successfully_destroyed_html', model: @block.to_s)
  end

  protected

  def website_id
    params[:website_id] || @block.about&.website.id
  rescue
  end

  def extranet_id
    params[:extranet_id] || @block.about&.extranet.id
  rescue
  end

  def journal_id
    params[:journal_id] || @block.about&.journal.id
  rescue
  end

  def about_path
    # La formation ou la page concernée
    path_method = "admin_#{@block.about.class.base_class.to_s.parameterize.underscore}_path"
    path_method_options = {
      id: @block.about_id,
      website_id: website_id,
      extranet_id: extranet_id,
      journal_id: journal_id
    }
    path_method_options[:lang] = @block.about.language.iso_code if @block.about.respond_to?(:language)
    public_send path_method, **path_method_options
  end

  def breadcrumb
    short_breadcrumb
    add_breadcrumb @block.about, about_path
    if @block.new_record?
      add_breadcrumb t('communication.block.choose_template')
    else
      add_breadcrumb @block
    end
  end

  def block_params
    params.require(:communication_block)
          .permit(:about_id, :about_type, :template_kind, :title, :data, :published)
          .merge(university_id: current_university.id)
  end
end
