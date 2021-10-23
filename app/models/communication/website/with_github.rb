module Communication::Website::WithGithub
  extend ActiveSupport::Concern

  included do
    after_save :publish_to_github
  end

  def github_content
    @content ||= github.read_file_at github_path
  end

  def github_frontmatter
    @frontmatter ||= FrontMatterParser::Parser.new(:md).call(github_content)
  end

  def github_file
    "#{ id }.html"
  end

  # Needs override
  def github_path_generated
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
