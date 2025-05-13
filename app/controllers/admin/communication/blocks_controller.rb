class Admin::Communication::BlocksController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Block,
                              through: :current_university,
                              through_association: :communication_blocks

  before_action :redirect_if_block_language_is_incorrect, only: [:edit, :update]

  def reorder
    ids = params[:ids] || []
    ids.values.each_with_index do |object, index|
      block = current_university.communication_blocks.find(object[:id])
      block.update(position: index + 1)
    end
  end

  def new
    @block.about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    breadcrumb
    render layout: 'admin/layouts/raw'
  end

  def show
    render layout: false
  end

  def edit
    @element = @block.template.default_element
    breadcrumb
    render layout: 'admin/layouts/raw'
  end

  def create
    if @block.save
      respond_to do |format|
        format.html {
          redirect_to [:edit, :admin, @block],
                      notice: t('admin.successfully_created_html', model: @block.to_s)
        }
        format.js { render json: {}, status: :created, location: [:edit, :admin, @block] }
      end
    else
      respond_to do |format|
        format.html {
          breadcrumb
          render :new, status: :unprocessable_entity
        }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def update
    if @block.update(block_params)
      respond_to do |format|
        format.html {
          redirect_to about_path,
                      notice: t('admin.successfully_updated_html', model: @block.to_s)
        }
        format.js { head :ok }
      end
    else
      respond_to do |format|
        format.html {
          breadcrumb
          add_breadcrumb t('edit')
          render :edit, status: :unprocessable_entity
        }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def duplicate
    # On réattribue à @block pour bénéficier du calcul dans about_path
    @block = @block.duplicate
    redirect_to about_path + "#block-#{@block.id}",
                notice: t('admin.successfully_duplicated_html', model: @block.to_s)
  end

  def copy
    return unless request.xhr?
    cookies.signed[Communication::Block::BLOCK_COPY_COOKIE] = {
      value: params[:id],
      path: '/admin'
    }
  end

  def paste
    about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    # On réattribue à @block pour bénéficier du calcul dans about_path
    @block = @block.paste(about)
    cookies.delete(Communication::Block::BLOCK_COPY_COOKIE, path: '/admin')
    redirect_to about_path + "#block-#{@block.id}",
                notice: t('admin.successfully_duplicated_html', model: @block.to_s)
  end

  def destroy
    path = about_path
    @block.destroy
    redirect_to path,
                notice: t('admin.successfully_destroyed_html', model: @block.to_s)
  end

  protected

  def redirect_if_block_language_is_incorrect
    return if @block.language == current_language
    redirect_to about_path, alert: t('admin.communication.block.language_mismatch_alert')
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
    # Les blocs sont toujours affectés à des localisations
    l10n = @block.about
    # La localisation porte sur un objet, par exemple une University::Person ou un Communication::Website::Post
    object_edited = l10n.about
    # La formation ou la page concernée
    path_method = "admin_#{object_edited.class.base_class.to_s.parameterize.underscore}_path"
    path_method_options = {
      id: object_edited.id,
      lang: l10n.language,
      website_id: website_id,
      extranet_id: extranet_id,
      journal_id: journal_id
    }
    public_send path_method, **path_method_options
  end

  def breadcrumb
    short_breadcrumb
    add_breadcrumb @block.about, about_path
    if @block.new_record?
      add_breadcrumb t('admin.communication.blocks.choose.title')
    else
      add_breadcrumb @block
    end
  end

  def block_params
    params.require(:communication_block)
          .permit(:about_id, :about_type, :template_kind, :title, :data, :published, :html_class)
          .merge(university_id: current_university.id)
  end
end
