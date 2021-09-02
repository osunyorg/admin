class Github
  attr_reader :access_token, :repository

  def self.publish_article(article)
    with_journal(article.journal).publish_article(article)
  end

  def self.publish_volume(volume)
    with_journal(volume.journal).publish_volume(volume)
  end

  def self.with_journal(journal)
    new(journal.access_token, journal.repository)
  end

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
  end

  def publish_article(article)
    data = ApplicationController.render(
      template: 'admin/research/journal/articles/jekyll',
      layout: false,
      assigns: { article: article }
    )
    publish local_directory: "tmp/articles",
            local_file: "#{article.id}.md",
            data: data,
            remote_file: "_articles/#{article.id}.md",
            commit_message: "Save article #{ article.title }"
  end

  def publish_volume(volume)
    data = ApplicationController.render(
      template: 'admin/research/journal/volumes/jekyll',
      layout: false,
      assigns: { volume: volume }
    )
    publish local_directory: "tmp/volumes",
            local_file: "#{volume.id}.md",
            data: data,
            remote_file: "_volumes/#{volume.id}.md",
            commit_message: "Save volume #{ volume.title }"
  end

  def publish(local_directory:, local_file:, data:, remote_file:, commit_message:)
    FileUtils.mkdir_p local_directory
    local_path = "#{local_directory}/#{ local_file }"
    File.write local_path, data
    begin
      content = client.content repository, path: remote_file
      sha = content[:sha]
    rescue
      sha = nil
    end
    client.create_contents  repository,
                            remote_file,
                            commit_message,
                            file: local_path,
                            sha: sha

  end

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end
end
