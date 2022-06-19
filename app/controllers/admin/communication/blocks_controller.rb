class Admin::Communication::BlocksController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Block,
                              through: :current_university,
                              through_association: :communication_blocks

  def reorder
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      block = current_university.communication_blocks.find(id)
      block.update position: index + 1
    end
  end

  def new
    @block.about_type = params[:about_type]
    @block.about_id = params[:about_id]
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
    @block.university = current_university
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

  def about_path
    # La formation ou la page concernée
    path_method = "admin_#{@block.about.class.to_s.parameterize.underscore}_path"
    send path_method, id: @block.about_id, website_id: website_id
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
          .permit(:about_id, :about_type, :template_kind, :title, :data)
  end
end
