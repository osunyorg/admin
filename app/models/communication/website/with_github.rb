module Communication::Website::WithGithub
  extend ActiveSupport::Concern

  included do
    after_save :publish_to_github
  end

  def content
    @content ||= github.read_file_at github_path
  end

  def frontmatter
    @frontmatter ||= FrontMatterParser::Parser.new(:md).call(content)
  end

  def content_without_frontmatter
    frontmatter.content
  end

  def github_file
    "#{ id }.html"
  end

  # Needs override
  def github_path
    ''
  end

  protected

  def github
    @github ||= Github.with_site(website)
  end

  # Needs override
  def publish_to_github
    ''
  end
  handle_asynchronously :publish_to_github
  
end
