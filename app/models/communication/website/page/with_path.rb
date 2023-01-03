module Communication::Website::Page::WithPath
  extend ActiveSupport::Concern

  included do
    before_validation :set_slug
    validate :validate_slug
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
    # Same website only, page published only
    # FIXME is it ever called for other websites?
    return unless website.id == communication_website_id && published
    current_git_path
  end

  def url
    return unless published
    return if website.url.blank?
    "#{website.url}#{path}".gsub('//', '/')
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}pages/#{slug_with_ancestors}/_index.html"
  end

  def git_path_prefix
    @git_path_prefix ||= git_path_content_prefix(website)
  end

  def set_slug
    self.slug = to_s.parameterize if self.slug.blank?
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

  def validate_slug
    slug_must_be_present
    slug_must_be_unique
    slug_must_have_proper_format
  end

  def slug_must_be_present
    errors.add(:slug, ActiveRecord::Errors.default_error_messages[:absent]) if slug.blank?
  end

  def slug_must_be_unique
    errors.add(:slug, ActiveRecord::Errors.default_error_messages[:taken]) if slug_unavailable?(slug)
  end

  def slug_must_have_proper_format
    # TODO method equivalent of:
    # validates :slug,
    #           format: {
    #             with: /\A[a-z0-9\-]+\z/,
    #             message: I18n.t('slug_error')
    #           },
    #           unless: :kind_home?
  end

end
