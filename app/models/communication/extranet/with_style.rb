module Communication::Extranet::WithStyle
  extend ActiveSupport::Concern

  included do
    before_validation :generate_css
  end

  protected

  def generate_css
    self.css = SassC::Sass2Scss.convert sass
  end
end