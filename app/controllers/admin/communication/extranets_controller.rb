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
    params.require(:communication_extranet)
          .permit(permitted_params)
          .merge(
            university_id: current_university.id
          )
  end

  def permitted_params
    permitted_params = params_base
    localizations_attributes = localization_params_base
    if can?(:create, Communication::Extranet)
      permitted_params += params_extended
      localizations_attributes += localization_params_extended
    end
    permitted_params << :default_language_id if @extranet&.persisted?
    permitted_params << {
      localizations_attributes: localizations_attributes
    }
    permitted_params
  end

  def params_base
    [
      :color
    ]
  end

  def params_extended
    [
      :about_id,
      :about_type,
      :feature_alumni,
      :feature_contacts,
      :feature_documents,
      :feature_jobs,
      :feature_posts,
      :has_sso,
      :host,
      :sass,
      :sso_cert,
      :sso_mapping,
      :sso_name_identifier_format,
      :sso_target_url
    ]
  end

  def localization_params_base
    [
      :cookies_policy,
      :favicon,
      :favicon_delete,
      :home_sentence,
      :id,
      :language_id,
      :logo,
      :logo_delete,
      :name,
      :privacy_policy,
      :published,
      :registration_contact,
      :terms
    ]
  end

  def localization_params_extended
    [
      :sso_button_label
    ]
  end
end
