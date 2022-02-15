class Admin::Communication::Website::BlocksController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Block, through: :website

  def reorder
    ids = params[:ids] || []
    first_page = nil
    ids.each.with_index do |id, index|
      block = @website.blocks.find(id)
      block.update position: index + 1
    end
  end

  def new
    @block.about_type = params[:about_type]
    @block.about_id = params[:about_id]
    breadcrumb
  end

  def edit
    breadcrumb
  end

  def create
    @block.university = @website.university
    @block.website = @website
    if @block.save
      redirect_to [:admin, @block.about], notice: t('admin.successfully_created_html', model: @block.to_s)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @block.update(block_params)
      redirect_to [:admin, @block.about], notice: t('admin.successfully_updated_html', model: @block.to_s)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @about = @block.about
    @block.destroy
    redirect_to [:admin, @about], notice: t('admin.successfully_destroyed_html', model: @block.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb @block.about.model_name.human(count: 2), [:admin, @block.about.class]
    add_breadcrumb @block.about, [:admin, @block.about]
    add_breadcrumb t('communication.website.block.choose_template')
  end


  def block_params
    params.require(:communication_website_block)
          .permit(:about_id, :about_type, :template, :data)
  end
end
