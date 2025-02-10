module Communication::Extranet::WithStyle
  extend ActiveSupport::Concern

  included do
    before_validation :generate_css
  end

  protected

  def generate_css
    if sass.blank?
      self.css = ''
      return
    end

    begin
      self.css = SassC::Engine.new(sass, syntax: :sass, style: :compressed).render
    rescue SassC::SyntaxError
      errors.add(:sass, :invalid)
    end
  end
end
