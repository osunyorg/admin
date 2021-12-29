class Github
  attr_reader :website, :access_token, :repository

  def self.with_website(website)
    new website
  end

  def initialize(website)
    @website = website
    @access_token = website&.access_token
    @repository = website&.repository
  end

  def valid?
    repository.present? && access_token.present?
  end

  def publish(path: nil,
              previous_path: nil,
              commit: nil,
              data:)
    local_path = "#{ tmp_directory }/#{ path }"
    Pathname(local_path).dirname.mkpath
    File.write local_path, data
    return if repository.blank?
    if !previous_path.blank? && path != previous_path
      move_file previous_path, path
    end
    client.create_contents  repository,
                            path,
                            commit,
                            file: local_path,
                            sha: file_sha(path)
    true
  rescue => e
    false
  end

  def add_to_batch( path: nil,
                    previous_path: nil,
                    data:)
    @batch ||= []
    file = find_in_tree previous_path
    if file.nil? # New file
      @batch << {
        path: path,
        mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
        type: 'blob',
        content: data
      }
    else # Existing file
      @batch << {
        path: previous_path,
        mode: file[:mode],
        type: file[:type],
        sha: nil
      }
      @batch << {
        path: path,
        mode: file[:mode],
        type: file[:type],
        content: data
      }
    end
  end

  def commit_batch(commit_message)
    new_tree = client.create_tree repository, @batch, base_tree: tree[:sha]
    commit = client.create_commit repository, commit_message, new_tree[:sha], branch_sha
    client.update_branch repository, default_branch, commit[:sha]
    @tree = nil
    true
  end

  def remove(path, commit_message)
    client.delete_contents repository, path, commit_message, file_sha(path)
    true
  rescue
    false
  end

  def read_file_at(path)
    data = client.content repository, path: path
    Base64.decode64 data.content
  rescue
    ''
  end

  def send_batch_to_website(objects, message: 'Batch objects')
    return unless valid?

    github_files = []
    objects.each do |object|
      next unless object.list_of_websites.include? website
      object.github_manifest.each do |manifest_item|
        github_file = object.github_files.where(website: website, manifest_identifier: manifest_item[:identifier]).first_or_create
        github_files << github_file
        github_file.add_to_batch(self)
      end
    end

    if commit_batch(message)
      github_files.each do |github_file|
        github_file.update_column :github_path, github_file.manifest_data[:generated_path].call(github_file)
      end
    end
  end
  handle_asynchronously :send_batch_to_website, queue: 'default'

  protected

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

  # https://medium.com/@obodley/renaming-a-file-using-the-git-api-fed1e6f04188
  def move_file(from, to)
    file = find_in_tree from
    return if file.nil?
    content = [{
      path: from,
      mode: file[:mode],
      type: file[:type],
      sha: nil
    },
    {
      path: to,
      mode: file[:mode],
      type: file[:type],
      sha: file[:sha]
    }]
    new_tree = client.create_tree repository, content, base_tree: tree[:sha]
    message = "Move #{from} to #{to}"
    commit = client.create_commit repository, message, new_tree[:sha], branch_sha
    client.update_branch repository, default_branch, commit[:sha]
    @tree = nil
    true
  rescue
    false
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

  def default_branch
    @default_branch ||= client.repo(repository)[:default_branch]
  end

  def branch_sha
    @branch_sha ||= client.branch(repository, default_branch)[:commit][:sha]
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
