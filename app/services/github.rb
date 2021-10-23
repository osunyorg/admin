class Github
  attr_reader :access_token, :repository

  def self.with_site(site)
    new site.access_token, site.repository
  end

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
  end

  def publish(kind: nil, # Deprecated
              file: nil, # Deprecated
              title: nil, # Deprecated
              path: nil,
              previous_path: nil,
              commit: nil,
              data:)
    if path
      local_path = "#{ tmp_directory }/#{ path }"
      remote_file = path
    else
      # Deprecated
      local_path = "#{ tmp_directory }/#{ file }"
      remote_file = "_#{ kind }/#{ file }"
    end
    Pathname(local_path).dirname.mkpath
    File.write local_path, data
    return if repository.blank?
    if !previous_path.blank? && path != previous_path
      move_file previous_path, path
    end
    commit ||= "Save #{ title }"
    client.create_contents  repository,
                            remote_file,
                            commit,
                            file: local_path,
                            sha: file_sha(remote_file)
  rescue
    # byebug
  end

  def send_file(attachment, path)
    return if repository.blank?
    commit_message = "[file] Save #{ path }"
    path_without_slash = path[1..-1]
    client.create_contents  repository,
                            path_without_slash,
                            commit_message,
                            attachment.download,
                            sha: file_sha(path)
  rescue
    # byebug
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

  protected

  # https://medium.com/@obodley/renaming-a-file-using-the-git-api-fed1e6f04188
  def move_file(from, to)
    file = find_in_tree from
    return if file.nil?
    content = [{
      path: to,
      mode: file[:mode],
      type: file[:type],
      sha: file[:sha]
    }]
    begin
    new_tree = client.create_tree repository, content, base_tree: tree[:sha]
    message = "Move #{from} to #{to}"
    commit = client.create_commit repository, message, new_tree[:sha], branch_sha
    [:main, :master].each do |branch|
      client.update_branch repository, branch, commit[:sha]
    end
    rescue
    end
  end

  def file_sha(path)
    begin
      content = client.content repository, path: path
      sha = content[:sha]
    rescue
      sha = nil
    end
    sha
  end

  def branch_sha
    unless @branch_sha
      [:main, :master].each do |branch|
        begin
          # Crashes if branch does not exist
          response = client.branch repository, branch
          @branch_sha = response['commit']['sha']
        end
        break if @branch_sha
      end
    end
    @branch_sha
  end

  def tree
    @tree ||= client.tree repository, branch_sha, recursive: true
  end

  def find_in_tree(path)
    tree[:tree].each do |file|
      return file if path == file[:path]
    end
    nil
  end

  def tmp_directory
    "tmp/github/#{repository}"
  end
end
