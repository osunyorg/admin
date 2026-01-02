module Admin::HasPreview
  extend ActiveSupport::Concern

  included do
    before_action :set_preview, only: :show
    before_action :prepare_preview, only: :preview
  end

  def preview
    render  template: 'admin/application/preview/preview',
            layout: 'admin/layouts/preview'
  end

  protected

  def set_preview
    @preview = true
  end
  
  def prepare_preview
    @website ||= resource.websites&.first || current_university.websites.first
    @body_class = resource.hugo_body_class    
    @body_class += ' full-width' if resource.try(:full_width)
  end

end