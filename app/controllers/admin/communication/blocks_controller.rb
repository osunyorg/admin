class Admin::Communication::BlocksController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Block,
                              through: :current_university,
                              through_association: :communication_blocks

  def reorder
    ids = params[:ids] || []
    ids.each.with_index do |identifier, index|
      parts = identifier.split('_')
      kind = parts.first
      id = parts.last
      if kind == 'block'
        @block = current_university.communication_blocks.find(id)
        @block.heading = @heading
        @block.position = index + 1
        @block.save
        @previous = nil
      elsif kind == 'heading'
        @heading = current_university.communication_block_headings.find(id)
        @heading.position = index + 1
        @heading.parent = @previous
        @heading.save
        @previous = @heading
      end
    end
    @block.about.sync_with_git
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
    @block.university = current_university
    if @block.save
      # No need to sync as content is empty
      redirect_to [:edit, :admin, @block],
                  notice: t('admin.successfully_created_html', model: @block.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @block.update(block_params)
      sync_with_git_if_necessary
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
    sync_with_git_if_necessary
    redirect_to path,
                notice: t('admin.successfully_destroyed_html', model: @block.to_s)
  end

  protected

  def sync_with_git_if_necessary
    return unless @block.about.respond_to?(:sync_with_git)
    @block.about.sync_with_git 
  end

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
  end
end
