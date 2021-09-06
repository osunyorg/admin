class Github
  attr_reader :access_token, :repository

  def self.with_site(site)
    new site.access_token, site.repository
  end

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
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

  def read_file_at(path)
    data = client.content repository, path: path
    Base64.decode64 data.content
  rescue
    ''
  end

  def pages
    list = client.contents repository, path: '_pages'
    list.map do |hash|
      page_with_id(hash[:name])
    end
  end

  def page_with_id(id)
    path = "_pages/#{id}"
    data = client.content repository, path: path
    raw = Base64.decode64 data.content
    parsed = FrontMatterParser::Parser.new(:md).call(raw)
    page = Communication::Website::Page.new
    page.id = id
    page.title = parsed.front_matter['title']
    page.permalink = parsed.front_matter['permalink']
    page.content = parsed.content
    page.raw = raw
    page
  end

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end
end
