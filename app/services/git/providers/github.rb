class Git::Providers::Github < Git::Providers::Abstract
  BASE_URL = "https://github.com".freeze
  COMMIT_BATCH_SIZE = 100

  include WithSecrets
  include WithTheme

  def url
    "#{BASE_URL}/#{repository}"
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
    # Handle newly created GitFiles which update existing remote files while having blank previous_path.
    path_to_check = previous_path.present? ? previous_path : path
    file = tree_item_at_path(path_to_check)
    # En cas de dissonnance entre l'analyzer et le provider, on raise une erreur
    raise "File to update does not exist on Git (repository: #{repository}, previous_path: #{previous_path}, path: #{path})" if file.nil?
    batch << {
      path: path_to_check,
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
    file = tree_item_at_path(path)
    return if file.nil?
    batch << {
      path: path,
      mode: file[:mode],
      type: file[:type],
      sha: nil
    }
  end

  def init_from_template(name)
    client.create_repository_from_template(
      ENV['GITHUB_WEBSITE_TEMPLATE_REPOSITORY'],
      name,
      {
        owner: ENV['GITHUB_WEBSITE_OWNER'],
        private: false
      }
    )
  end

  def push(commit_message)
    return if !valid? || batch.empty?
    commit = create_commit_from_batch(batch, commit_message)
    client.update_branch repository, default_branch, commit[:sha]
    # The repo changed, invalidate the tree
    @tree = nil
    @tree_items_by_path = nil
    #
    true
  end

  def create_commit_from_batch(batch, commit_message)
    base_tree_sha = tree[:sha]
    base_commit_sha = branch_sha
    commit = nil
    commits_count = (batch.size / COMMIT_BATCH_SIZE.to_f).ceil
    batch.each_slice(COMMIT_BATCH_SIZE).with_index do |sub_batch, i|
      sub_commit_message = commit_message
      sub_commit_message += " (#{i+1}/#{commits_count})" if commits_count > 1
      commit = create_sub_commit(sub_batch, sub_commit_message, base_tree_sha, base_commit_sha)
      base_tree_sha = commit[:tree][:sha]
      base_commit_sha = commit[:sha]
    end
    commit
  end

  def create_sub_commit(sub_batch, sub_commit_message, base_tree_sha, base_commit_sha)
    puts "Creating commit with #{sub_batch.size} files."
    new_tree = client.create_tree repository, sub_batch, base_tree: base_tree_sha
    client.create_commit repository, sub_commit_message, new_tree[:sha], base_commit_sha
  end

  def computed_sha(string)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{string.bytesize}\x00#{string}"
  end

  def git_sha(path)
    return if path.nil?
    # Try to find in stored tree to avoid multiple queries
    tree_item_at_path(path)&.dig(:sha)
  end

  def files_in_the_repository
    @files_in_the_repository ||= tree[:tree].map { |file| file[:path] }
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def default_branch
    @default_branch ||= branch.presence || 'main'
  end

  def branch_sha
    @branch_sha ||= client.branch(repository, default_branch)[:commit][:sha]
  end

  def tree_item_at_path(path)
    tree_items_by_path[path] if tree_items_by_path.has_key? path
  end

  def tree_items_by_path
    unless @tree_items_by_path
      @tree_items_by_path = {}
      tree[:tree].each do |hash|
        path = hash[:path]
        @tree_items_by_path[path] = {
          mode: hash[:mode],
          type: hash[:type],
          sha: hash[:sha]
        }
      end
    end
    @tree_items_by_path
  end

  def tree
    @tree ||= client.tree repository, branch_sha, recursive: true
  end

end
