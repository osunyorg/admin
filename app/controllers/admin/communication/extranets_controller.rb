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
    @hero_summary = true
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
    permitted_params = base_params
    localizations_attributes = base_localization_params
    if can?(:create, Communication::Extranet)
      permitted_params += extended_params
      localizations_attributes += extended_localization_params
    end
    permitted_params << :default_language_id if @extranet&.persisted?
    permitted_params << {
      localizations_attributes: localizations_attributes
    }
    permitted_params
  end

  def base_params
    [
      :color
    ]
  end

  def base_localization_params
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

  def extended_params
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
      :upper_menu,
      :sso_cert,
      :sso_mapping,
      :sso_name_identifier_format,
      :sso_target_url
    ]
  end

  def extended_localization_params
    [
      :sso_button_label
    ]
  end
end
