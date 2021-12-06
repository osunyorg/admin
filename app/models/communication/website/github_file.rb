# == Schema Information
#
# Table name: communication_website_github_files
#
#  id          :uuid             not null, primary key
#  about_type  :string           not null
#  github_path :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  about_id    :uuid             not null
#  website_id  :uuid             not null
#
# Indexes
#
#  index_communication_website_github_files_on_about       (about_type,about_id)
#  index_communication_website_github_files_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::GithubFile < ApplicationRecord
  belongs_to :website, class_name: 'Communication::Website'
  belongs_to :about, polymorphic: true

  after_destroy :remove_from_github

  def publish
    return unless github.valid?
    if github.publish(path: about.github_path_generated,
                      previous_path: github_path,
                      commit: github_commit_message,
                      data: about.to_jekyll(self))
      update_column :github_path, about.github_path_generated
    end
  end
  handle_asynchronously :publish, queue: 'default'

  def add_to_batch(github)

  end

  def github_frontmatter
    @github_frontmatter ||= begin
      github_content = github.read_file_at(github_path)
      FrontMatterParser::Parser.new(:md).call(github_content)
    rescue
      FrontMatterParser::Parser.new(:md).call('')
    end
  end

  protected

  def remove_from_github
    return unless github.valid?
    github.remove(github_path, github_remove_commit_message)
  end

  def github
    @github ||= Github.with_website(website)
  end

  def github_commit_message
    "[#{about.class.name.demodulize}] Save #{about.to_s}"
  end

  def github_remove_commit_message
    "[#{about.class.name.demodulize}] Remove #{about.to_s}"
  end
end
