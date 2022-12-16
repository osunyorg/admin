module Communication::Website::Page::WithPath
  extend ActiveSupport::Concern

  included do
    validates :slug,
              presence: true,
              unless: :kind_home?
    validate  :slug_must_be_unique
    validates :slug,
              format: {
                with: /\A[a-z0-9\-]+\z/,
                message: I18n.t('slug_error')
              },
              unless: :kind_home?

    before_validation :check_slug
  end

  def path
    path = ''
    # TODO i18n remplacer le choix de la langue
    if website.languages.many?
      path += "/#{website.default_language.iso_code}"
    end
    path += "/#{slug_with_ancestors}/"
    path.gsub(/\/+/, '/')
  end

  def slug_with_ancestors
    (ancestors.map(&:slug) << slug).reject(&:blank?).join('/')
  end

  def git_path(website)
    return unless website.id == communication_website_id && published

    path = git_path_content_prefix(website)
    if kind_home?
      path += "_index.html"
    elsif has_special_git_path?
      path += "#{kind.split('_').last}/_index.html"
    else
      path += "pages/#{slug_with_ancestors}/_index.html"
    end

    path
  end

  def url
    return unless published
    return if website.url.blank?
    "#{website.url}#{path}"
  end

  protected

  def check_slug
    self.slug = to_s.parameterize if self.slug.blank? && !kind_home?
    current_slug = self.slug
    n = 0
    while slug_unavailable?(self.slug)
      n += 1
      self.slug = [current_slug, n].join('-')
    end
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def slug_must_be_unique
    errors.add(:slug, ActiveRecord::Errors.default_error_messages[:taken]) if slug_unavailable?(slug)
  end

end
