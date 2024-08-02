class Admin::Communication::Websites::LocalizationsController < Admin::Communication::Websites::ApplicationController
  before_action :load_localization
  before_action :set_feature_nav, only: [:show, :update]

  def show
    breadcrumb
  end

  def update
    if @localization.update_and_sync(localization_params)
      redirect_to admin_communication_website_localization_path, notice: t('admin.successfully_updated_html', model: Communication::Website::Localization.model_name.human)
    else
      breadcrumb
      render :show, status: :unprocessable_entity
    end
  end

  protected

  def set_feature_nav
    @feature_nav = 'navigation/admin/communication/website/settings'
  end

  def load_localization
    @localization = @website.find_or_create_localization_for(current_language)
    authorize! :update, @localization
  end

  def breadcrumb
    super
    add_breadcrumb t('admin.subnav.settings')
    add_breadcrumb  t('admin.communication.website.localizations.title')
  end

  def localization_params
    params.require(:communication_website_localization)
    .permit(
      :name,
      :social_email, :social_facebook, :social_github, :social_instagram, :social_linkedin,
      :social_mastodon, :social_peertube, :social_tiktok, :social_vimeo, :social_x, :social_youtube
    )
  end
end
