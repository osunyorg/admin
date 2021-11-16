module WithPublicationToWebsites
  extend ActiveSupport::Concern

  included do
    after_save_commit :publish_to_github
  end

  def publish_to_website(website)
    github = Github.new website.access_token, website.repository
    return unless github.valid?
    github.publish  path: "_#{path_root}/#{ id }.md",
                    data: to_jekyll,
                    commit: "[#{element_name}] Save #{to_s}"
  end

  def github_frontmatter
    @frontmatter ||= FrontMatterParser::Parser.new(:md).call(github_content)
  rescue
    FrontMatterParser::Parser.new(:md).call('')
  end

  protected

  def to_jekyll
    ApplicationController.render(
      template: "admin/#{path_relative}/jekyll",
      layout: false,
      assigns: { object: self }
    )
  end

  def publish_to_github
    websites.each { |website| publish_to_website(website) }
  end

  # return "Program"
  def element_name
    self.class.name.demodulize
  end

  # return "programs"
  def path_root
    element_name.pluralize.downcase
  end

  # return "education/programs"
  def path_relative
    self.class.name.underscore.pluralize
  end


end
