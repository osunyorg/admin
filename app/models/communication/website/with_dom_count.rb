module Communication::Website::WithDomCount
  extend ActiveSupport::Concern

  DEFAULT_DOM_COUNT = 250

  # L'idée est de fournir un socle correspondant au header et au footer
  def dom_count
    # TODO count menus
    DEFAULT_DOM_COUNT
  end

end
