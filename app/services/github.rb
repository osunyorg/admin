class Github
  attr_reader :access_token, :repository

  def self.with_site(site)
    new site.access_token, site.repository
  end

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
  end

  def publish(kind:, file:, title:, data:)
    local_directory = "tmp/jekyll/#{ kind }"
    FileUtils.mkdir_p local_directory
    local_path = "#{ local_directory }/#{ file }"
    File.write local_path, data
    remote_file = "_#{ kind }/#{ file }"
    begin
      content = client.content repository, path: remote_file
      sha = content[:sha]
    rescue
      sha = nil
    end
    commit_message ||= "[#{kind}] Save #{ title }"
    return if repository.blank?
    client.create_contents  repository,
                            remote_file,
                            commit_message,
                            file: local_path,
                            sha: sha
  rescue
  end

  def send_file(attachment, path)
    begin
      content = client.content repository, path: path
      sha = content[:sha]
    rescue
      sha = nil
    end
    commit_message ||= "[file] Save #{ path }"
    return if repository.blank?
    path_without_slash = path[1..-1]
    client.create_contents  repository,
                            path_without_slash,
                            commit_message,
                            attachment.download,
                            sha: sha
  rescue
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
