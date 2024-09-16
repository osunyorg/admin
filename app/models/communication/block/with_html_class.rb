module Communication::Block::WithHtmlClass
  extend ActiveSupport::Concern

  included do
    before_validation :parameterize_html_class
  end

  def html_class_prepared
    return if html_class.blank?
    html_class.split(' ')
              .map { |klass| "block-class-#{klass}" }
              .join(' ')
  end

  protected

  def parameterize_html_class
    return if html_class.blank?
    self.html_class = html_class.split(' ')
                                .map { |klass| klass.parameterize }
                                .join(' ')
  end
end