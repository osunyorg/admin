module WithGithub
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

  def github_path_generated
    '' # Needs override
  end

  protected

  def github
    @github ||= Github.with_site(website)
  end

  def github_commit_message
    "[#{self.class.name.demodulize}] Save #{ to_s }"
  end

  def publish_to_github
    if github.publish(path: github_path_generated,
                      previous_path: github_path,
                      commit: github_commit_message,
                      data: to_jekyll)
      update_column :github_path, github_path_generated
    end
  end
  handle_asynchronously :publish_to_github, queue: 'default'
end
