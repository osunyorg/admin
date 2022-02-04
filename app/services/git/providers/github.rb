class Git::Providers::Github
  attr_reader :access_token, :repository

  def initialize(access_token, repository)
    @access_token = access_token
    @repository = repository
  end

  def create_file(path, content)
    batch << {
      path: path,
      mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
      type: 'blob',
      content: content
    }
  end

  def update_file(path, previous_path, content)
    file = find_in_tree previous_path
    return if file.nil?
    batch << {
      path: previous_path,
      mode: file[:mode],
      type: file[:type],
      sha: nil
    }
    batch << {
      path: path,
      mode: file[:mode],
      type: file[:type],
      content: content
    }
  end

  def destroy_file(path)
    file = find_in_tree path
    return if file.nil?
    batch << {
      path: path,
      mode: file[:mode],
      type: file[:type],
      sha: nil
    }
  end

  def push(commit_message)
    return if !valid? || batch.empty?
    new_tree = client.create_tree repository, batch, base_tree: tree[:sha]
    commit = client.create_commit repository, commit_message, new_tree[:sha], branch_sha
    client.update_branch repository, default_branch, commit[:sha]
    true
  end

  def git_sha(path)
    begin
      content = client.content repository, path: path
      sha = content[:sha]
    rescue
      sha = nil
    end
    sha
  end

  def valid?
    repository.present? && access_token.present?
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def batch
    @batch ||= []
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
end
