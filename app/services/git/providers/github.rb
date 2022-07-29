class Git::Providers::Github < Git::Providers::Abstract
  def create_file(path, content)
    batch << {
      path: path,
      mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
      type: 'blob',
      content: content
    }
  end

  def update_file(path, previous_path, content)
    file = tree_item_for_path(previous_path)
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
    file = tree_item_for_path(path)
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

  def computed_sha(string)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{string.bytesize}\x00#{string}"
  end

  def git_sha(path)
    return if path.nil?
    # Try to find in stored tree to avoid multiple queries
    return tree_item_for_path(path)&.dig(:sha)
    # This is still generating too many requests, so we try based only on the tree
    # begin
    #   # The fast way, with no query, does not work.
    #   # Let's query the API.
    #   content = client.content repository, path: path
    #   return content[:sha]
    # rescue
    # end
    nil
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def default_branch
    @default_branch ||= client.repo(repository)[:default_branch]
  end

  def branch_sha
    @branch_sha ||= client.branch(repository, default_branch)[:commit][:sha]
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

  def tree_item_for_path(path)
    tree_items_by_path[path] if tree_items_by_path.has_key? path
  end
end
