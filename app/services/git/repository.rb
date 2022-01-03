class Git::Repository
  attr_reader :website, :commit_message

  def initialize(website)
    @website = website
  end

  def add_git_file(git_file)
    @commit_message = "[#{ git_file.about.class.name }] Save #{ git_file.about }" if git_files.empty?
    git_files << git_file
  end

  def sync!
    return unless valid?
    return if git_files.empty?
    sync_git_files
    mark_as_synced if commit_batch
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def access_token
    @access_token ||= website&.access_token
  end

  def repository
    @repository ||= website&.repository
  end

  def provider
    @provider ||= Git::Providers::Github.new
  end

  def git_files
    @git_files ||= []
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

  def valid?
    repository.present? && access_token.present?
  end

  def sync_git_files
    git_files.each do |git_file|
      next if git_file.synced?
      add_to_batch  path: git_file.path,
                    previous_path: git_file.previous_path,
                    data: git_file.to_s
    end
  end

  def add_to_batch( path: nil,
                    previous_path: nil,
                    data:)
    file = find_in_tree previous_path
    if file.nil? # New file
      batch << {
        path: path,
        mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
        type: 'blob',
        content: data
      }
    elsif previous_path != path || git_sha(previous_path) != sha(data)
      # Different path or content
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
        content: data
      }
    end
  end

  def commit_batch
    return if batch.empty?
    new_tree = client.create_tree repository, batch, base_tree: tree[:sha]
    commit = client.create_commit repository, commit_message, new_tree[:sha], branch_sha
    client.update_branch repository, default_branch, commit[:sha]
    true
  end

  def mark_as_synced
    git_files.each do |git_file|
      git_file.update_columns previous_path: git_file.path, previous_sha: git_file.sha
    end
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

  def sha(data)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{data.bytesize}\x00#{data}"
  end

  def find_in_tree(path)
    tree[:tree].each do |file|
      return file if path == file[:path]
    end
    nil
  end
end
