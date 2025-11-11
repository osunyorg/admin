module Admin::HasPreview
  extend ActiveSupport::Concern

  included do
    before_action :set_preview, only: :show
  end

  def preview
    render  template: 'admin/application/preview/preview',
            layout: 'admin/layouts/preview'
  end

  protected
  
  def set_preview
    @preview = true
  end

end