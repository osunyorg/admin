class Admin::Communication::Websites::SettingsController < Admin::Communication::Websites::ApplicationController
  # Ce n'est pas une ressource nested comme dependencies,
  # donc on doit charger explicitement pour utiliser id et pas website_id
  load_and_authorize_resource :website,
                              id_param: :id,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  before_action :set_feature_nav

  def federation
    @source_websites = current_university.websites
                                         .where.not(id: @website.id)
                                         .ordered(current_language)
    breadcrumb
    add_breadcrumb t('admin.communication.website.federation.label')
  end

  def language
    breadcrumb
    add_breadcrumb current_language
  end

  def redirects
    @permalinks = @website.permalinks
                          .not_current
                          .ordered
                          .page(params[:page])
    breadcrumb
    add_breadcrumb t('admin.communication.website.redirects.label')
  end

  def technical
    breadcrumb
    add_breadcrumb t('admin.communication.website.technical.label')
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
  end

  def set_feature_nav
    @l10n = @website.localization_for(current_language)
    @feature_nav = 'navigation/admin/communication/website/settings'
  end
end
