class Admin::Communication::Websites::AlertsController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Alert,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @alerts = @alerts.filter_by(params[:filters], current_language)
                     .ordered(current_language)
                     .page(params[:page])
    breadcrumb
  end

  def publish
    @l10n.publish!
    redirect_back fallback_location: admin_communication_website_alert_path(@alert),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @alert.website = @website
    if @alert.save
      redirect_to admin_communication_website_alert_path(@alert),
                  notice: t('admin.successfully_created_html', model: @alert.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @alert.update(alert_params)
      redirect_to admin_communication_website_alert_path(@alert),
                  notice: t('admin.successfully_updated_html', model: @alert.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @alert.destroy
    redirect_to admin_communication_website_alerts_url,
                notice: t('admin.successfully_destroyed_html', model: @alert.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website.human_attribute_name(:feature_alerts),
                    admin_communication_website_alerts_path
    breadcrumb_for @alert
  end

  def alert_params
    params.require(:communication_website_alert)
          .permit(
            :kind,
            localizations_attributes: [
              :id, :title, :description, :published, :published_at, :slug,
              :cta, :cta_label, :cta_url, :language_id
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
