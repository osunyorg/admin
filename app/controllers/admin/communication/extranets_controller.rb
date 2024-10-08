class Admin::Communication::ExtranetsController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet,
                              through: :current_university,
                              through_association: :communication_extranets

  include Admin::Localizable

  def index
    @extranets = @extranets.filter_by(params[:filters], current_language)
                           .ordered(current_language)
                           .page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    if @extranet.save
      redirect_to [:admin, @extranet], notice: t('admin.successfully_created_html', model: @extranet.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @extranet.update(extranet_params)
      redirect_to [:admin, @extranet], notice: t('admin.successfully_updated_html', model: @extranet.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @extranet.destroy
    redirect_to admin_communication_websites_url, notice: t('admin.successfully_destroyed_html', model: @extranet.to_s_in(current_language))
  end

  def confirm_localization
    @about_gid = params[:about]
    @about = GlobalID::Locator.locate(@about_gid)
  end

  def do_confirm_localization
    @about_gid = params[:about]
    @about = GlobalID::Locator.locate(@about_gid)
    @extranet.localize_in!(current_language)
    @about.localize_in!(current_language)
    redirect_to [:edit, :admin, @about]
  end

  protected

  def extranet_params
    allowed_params = [
      :color
    ]
    localizations_attributes = [
      :id, :language_id,
      :name, :published,
      :registration_contact,
      :logo, :logo_delete, 
      :favicon, :favicon_delete, 
      :home_sentence,
      :terms, :privacy_policy, :cookies_policy
    ]  
    if can?(:create, Communication::Extranet)
      allowed_params += [
        :host, :about_id, :about_type, :sass,
        :feature_alumni, :feature_documents, :feature_contacts, :feature_jobs, :feature_posts,
        :has_sso, :sso_target_url, :sso_cert, :sso_name_identifier_format, :sso_mapping
      ]
      localizations_attributes += [
        :sso_button_label
      ]
    end
    allowed_params << :default_language_id if @extranet&.persisted?
    allowed_params << { localizations_attributes: localizations_attributes }
    params.require(:communication_extranet)
          .permit(allowed_params)
          .merge(
            university_id: current_university.id
          )
  end
end
