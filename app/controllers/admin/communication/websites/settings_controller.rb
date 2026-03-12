class Admin::Communication::Websites::SettingsController < Admin::Communication::Websites::ApplicationController
  before_action :set_feature_nav

  def language
    # FIXME @SebouChu je capte pas
    @website = current_university.websites.find(params[:id])
    @l10n = @website.localization_for(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb current_language
  end

  def federation
    # FIXME @SebouChu je capte pas
    @website = current_university.websites.find(params[:id])
    @l10n = @website.localization_for(current_language)
    @source_websites = current_university.websites
                                         .where.not(id: @website.id)
                                         .ordered(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb t('admin.communication.website.federation.label')
  end

  def technical
    # FIXME @SebouChu je capte pas
    @website = current_university.websites.find(params[:id])
    @l10n = @website.localization_for(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb t('admin.communication.website.technical.label')
  end
  
  protected

  def set_feature_nav
    @feature_nav = 'navigation/admin/communication/website/settings'
  end
end