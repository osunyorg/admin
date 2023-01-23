class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :load_filters, only: :index

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
    object.persisted? ? add_breadcrumb(object, [:admin, object, options])
                      : add_breadcrumb(t('create'))
  end

  def load_filters
    @filters = []
    filter_class_name = "::Filters::#{self.class.to_s.gsub('Controller', '')}"
    # filter_class will be nil if filter does not exist
    filter_class = filter_class_name.safe_constantize
    @filters = filter_class.new(current_user).list unless filter_class.nil?
  end
end
