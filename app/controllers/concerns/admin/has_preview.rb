module Admin::HasPreview
  extend ActiveSupport::Concern

  included do
    before_action :set_preview, only: :show
  end

  def preview
    @body_class = ''
    @full_width = @l10n.about.try(:full_width)    
    @body_class += 'full-width' if @full_width
    render  template: 'admin/application/preview/preview',
            layout: 'admin/layouts/preview'
  end

  protected
  
  def set_preview
    @preview = true
  end

end