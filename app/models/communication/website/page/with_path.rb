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

    before_validation :check_slug, :make_path
    after_save :update_children_paths, if: :saved_change_to_path?
  end

  def generated_path
    "#{parent&.path}#{slug}/".gsub(/\/+/, '/')
  end

  def path_without_language
    if kind_home?
      "/"
    elsif parent_id.present?
      "#{parent&.path_without_language}#{slug}/".gsub(/\/+/, '/')
    else
      "/#{slug}/".gsub(/\/+/, '/')
    end
  end

  def git_path(website)
    return unless website.id == communication_website_id && published

    path = git_path_content_prefix(website)
    if kind_home?
      path += "_index.html"
    elsif has_special_git_path?
      path += "#{kind.split('_').last}/_index.html"
    else
      path += "pages/#{path_without_language}/_index.html"
    end

    path
  end

  def url
    return unless published
    return if website.url.blank?
    "#{website.url}#{path}"
  end

  protected

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

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

  def make_path
    self.path = kind_home? ? "#{language_prefix}/" : generated_path
  end

  def slug_must_be_unique
    errors.add(:slug, ActiveRecord::Errors.default_error_messages[:taken]) if slug_unavailable?(slug)
  end

end
