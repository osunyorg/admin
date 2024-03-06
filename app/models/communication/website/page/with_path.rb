module Communication::Website::Page::WithPath
  extend ActiveSupport::Concern

  def path
    path = ''
    if website.languages.many?
      path += "/#{language.iso_code}"
    end
    path += "/#{slug_with_ancestors}/"
    path.gsub(/\/+/, '/')
  end

  # FIXME @arnaud : Should it be moved to Sluggable? To discuss
  def slug_with_ancestors
    (ancestors.map(&:slug) << slug).reject(&:blank?).join('/')
  end

  def git_path(website)
    return unless website.id == communication_website_id && published
    current_git_path
  end

  # pages/_index.html
  # pages/page-de-test/_index.html
  def git_path_relative
    ['pages', slug_with_ancestors, '_index.html'].compact_blank.join('/')
  end

  def url
    return unless published
    return if website.url.blank?
    # do not use a global Static.clean_path here because url has protocol with 2 slashes!
    # remove trailing slash if needed, because path begins with a slash
    "#{Static.remove_trailing_slash website.url}#{Static.clean_path path}"
  end

  protected

  def current_git_path
    @current_git_path ||= git_path_prefix + git_path_relative
  end

  def git_path_prefix
    @git_path_prefix ||= git_path_content_prefix(website)
  end

end
