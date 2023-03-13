class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  include WithFeatures
  include Admin::Filterable

  def set_theme
    current_user.update_column :admin_theme, params[:theme]
    redirect_to admin_root_path
  end

  protected

  def breadcrumb
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
  end

  def short_breadcrumb
    @menu_collapsed = true
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
    add_breadcrumb '...'
  end

  def breadcrumb_for(object, **options)
    return unless object
    title = object.to_s.truncate(50)
    object.persisted? ? add_breadcrumb(title, [:admin, object, options])
                      : add_breadcrumb(t('create'))
  end


end
