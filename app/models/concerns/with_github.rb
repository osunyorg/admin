module WithGithub
  extend ActiveSupport::Concern

  included do
    after_save_commit :publish_to_github
    after_touch :publish_to_github
    after_destroy :remove_from_github
  end

  def force_publish!
    publish_to_github
  end

  def github_frontmatter
    @github_frontmatter ||= begin
      github_content = github.read_file_at(github_path)
      FrontMatterParser::Parser.new(:md).call(github_content)
    rescue
      FrontMatterParser::Parser.new(:md).call('')
    end
  end

  def github_path_generated
    raise NotImplementedError
  end

  protected

  def github
    @github ||= Github.with_website(website)
  end

  def github_commit_message
    "[#{self.class.name.demodulize}] Save #{to_s}"
  end

  def github_remove_commit_message
    "[#{self.class.name.demodulize}] Remove #{to_s}"
  end

  def publish_to_github
    return unless github.valid?
    if github.publish(path: github_path_generated,
                      previous_path: github_path,
                      commit: github_commit_message,
                      data: to_jekyll)
      update_column :github_path, github_path_generated
    end
  end
  handle_asynchronously :publish_to_github, queue: 'default'

  def remove_from_github
    return unless github.valid?
    github.remove(github_path, github_remove_commit_message)
  end
end
