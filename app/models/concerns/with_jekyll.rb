module WithJekyll
  extend ActiveSupport::Concern

  included do
    def to_jekyll
      ApplicationController.render(
        template: "admin/#{self.class.name.underscore.pluralize}/jekyll",
        layout: false,
        assigns: { self.class.name.demodulize.underscore => self }
      )
    end
  end

end
