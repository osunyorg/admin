class ApplicationController < ActionController::Base
  include WithDomain
  include WithErrors
  include WithFeatures
  include WithLocale
  include WithMaintenance

  before_action :ensure_university, :authenticate_user!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  def background_tasks_count
    @background_tasks_count ||= GoodJob::Job.where(finished_at: nil).count
  end
  helper_method :background_tasks_count

  protected

  # Deprecated
  def render_as_plain_text(partial: nil)
    render partial, layout: false, content_type: "text/plain; charset=utf-8"
  end

  def current_ability
    @current_ability ||= Ability.for(current_user)
  end

  def ensure_university
    render_forbidden unless current_university
  end
end
